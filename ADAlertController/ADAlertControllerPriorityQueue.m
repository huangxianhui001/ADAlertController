//
//  ADAlertControllerPriorityQueue.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAlertControllerPriorityQueue.h"
#import "ADAlertController.h"
#import "ADAlertController+Private.h"
#import <objc/runtime.h>
#import "UIViewController+ADAlertControllerTopVisible.h"

#define Parent(i) ((i - 1) >> 1)
#define LChild(i) (1 + ((i) << 1))
#define RChild(i) (((i) + 1) << 1 )

///因为插入时是将元素插入到队列的末尾,在上滤的过程中,为了保持父子节点的次序与插入顺序保持同样的次序
///在父子节点进行比较时,只要父节点的优先级是不小于子节点的,即认为此时已经满足了堆序性
///在删除最大节点时,是直接将最末尾的节点放到最开始的位置,然后执行下滤过程,这里同样为了保持插入的次序
///在完成最大堆后能够保持不变,在下滤的比较就需要子节点必须小于父节点,否则就需要交换,故此,在ChildCompareParentBlock的比较中,需要加入是否上滤的条件


///比较父节点是否大于子节点,第一个参数为子节点,第二个参数为父节点,第三个为是否上滤
typedef BOOL(^ChildCompareParentBlock)(id<ADAlertControllerPriorityQueueProtocol> childNode, id<ADAlertControllerPriorityQueueProtocol>parentNode,BOOL up);

///从两个孩子节点中决定哪个作为新的父节点
typedef id<ADAlertControllerPriorityQueueProtocol> (^SearchProperParentBlock)(id<ADAlertControllerPriorityQueueProtocol> leftChild, id<ADAlertControllerPriorityQueueProtocol> rightChild);

/// 对 UIViewController 的 viewDidAppear 方法进行交换
@interface UIViewController(ADAlertControllerQueueSupport)
- (void)alertController_viewDidAppear:(BOOL)animated;

///是否正在显示黑名单里面的控制器
+ (BOOL)isShowBlackListController;

@end

@interface NSObject (ADPriorityQueueExtention)

/// 添加此属性只是为了解决从两个同样优先级的孩子节点中,决定出哪个为合适的父节点,为了与插入次序保持同样的次序显示
@property (nonatomic, assign) NSTimeInterval ad_insertTimeInterval;
@end

@interface ADAlertControllerPriorityQueue ()<NSCopying>
@property (nonatomic, strong) NSMutableArray<id<ADAlertControllerPriorityQueueProtocol>> *queue;

@property (strong, nonatomic) NSOperationQueue *alertOperationQueue;
@property (strong, nonatomic) dispatch_semaphore_t semaphore;

///子节点与父节点是否交换的条件
@property (nonatomic, copy) ChildCompareParentBlock parentChildNeedSwapBlock;
/// 从两个子节点中寻找可能的父节点
@property (nonatomic, copy) SearchProperParentBlock searchProperParentBlock;

/// 当前显示的 alertController
@property (weak, nonatomic) ADAlertController *currentAlertController;

@end

@implementation ADAlertControllerPriorityQueue

+ (instancetype)shareInstance
{
    static ADAlertControllerPriorityQueue *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class]alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.queue = [[NSMutableArray alloc] initWithCapacity:10];
        self.alertOperationQueue = [[NSOperationQueue alloc] init];
        self.alertOperationQueue.name = @"com.adalertcontroller.alertoperationqueue";
        self.alertOperationQueue.maxConcurrentOperationCount = 1;
        self.semaphore = dispatch_semaphore_create(0);
        
        self.parentChildNeedSwapBlock = ^BOOL(id<ADAlertControllerPriorityQueueProtocol> childNode, id<ADAlertControllerPriorityQueueProtocol> parentNode, BOOL up) {
            if (up) {
                //上滤时,仅在子节点严格大于父节点时才需要交换
                return childNode.alertPriority > parentNode.alertPriority;
            }else{
                //下滤时,如果父子优先级相同,需要比较插入时间
                if (childNode.alertPriority == parentNode.alertPriority) {
                    return (((NSObject *)childNode).ad_insertTimeInterval < ((NSObject *)parentNode).ad_insertTimeInterval);
                }
                //当父节点不大于子节点就需要交换
                return parentNode.alertPriority <= childNode.alertPriority;
            }
        };
        
        self.searchProperParentBlock = ^id<ADAlertControllerPriorityQueueProtocol>(id<ADAlertControllerPriorityQueueProtocol> leftChild, id<ADAlertControllerPriorityQueueProtocol> rightChild) {
            if (leftChild.alertPriority > rightChild.alertPriority) {
                //左节点优先级大于右节点,返回左节点
                return leftChild;
            }else if (leftChild.alertPriority == rightChild.alertPriority) {
                //左右节点优先级相同,比较插入时间
                if (((NSObject *)leftChild).ad_insertTimeInterval < ((NSObject *)rightChild).ad_insertTimeInterval) {
                    return leftChild;
                }
            }
            
            return rightChild;
        };
    }
    return self;
}
#pragma mark - logic

/// 处理插入新元素的情况
/// @param element 新插入的元素
- (void)handlerInsertElement:(id<ADAlertControllerPriorityQueueProtocol>)element
{
    if (!self.currentAlertController) {
        //当前暂没有显示 alertController
        [self showNext];
    }else if (self.currentAlertController.alertPriority < element.alertPriority){
        //若当前显示的 alertController 优先级较插入的低,需要隐藏当前的
        //设置为 NO,不会在隐藏时被移除
        self.currentAlertController.deleteWhenHiden = NO;

        //判断是否已经显示了 currentAlertController
        if (self.currentAlertController.isShow) {
            //执行隐藏方法,会自动显示下一个可用的警告框视图
            [self.currentAlertController hiden];
            
        }else{
            self.currentAlertController.donotShow = YES;
        }
    }else if (self.currentAlertController.alertPriority == element.alertPriority &&
              self.currentAlertController.autoHidenWhenInsertSamePriority){
        //当前显示的与入队列的 alertController 优先级相同,且当前警告框允许被自动覆盖
        self.currentAlertController.deleteWhenHiden = YES;
        
        if (self.currentAlertController.isShow) {
            //执行隐藏方法,会自动显示下一个可用的警告框视图
            [self.currentAlertController hiden];
        }else{
            self.currentAlertController.donotShow = YES;
        }
    }
}

- (BOOL)checkShowNextValidity
{
    if (!self.currentAlertController && [ADAlertControllerPriorityQueue getMax]) {
        return YES;
    }return NO;
}

- (void)showNext
{
    if (![UIViewController isShowBlackListController]) {
        ADAlertController *nextAlertController = (ADAlertController *)[ADAlertControllerPriorityQueue getMax];
        if (nextAlertController) {
            NSUInteger parentIndex = 0;
            NSUInteger childIndex = 0;
            while (![nextAlertController canShow]) {
                childIndex = [self fineBestChildIndexWithParentIndex:parentIndex];
                nextAlertController = (ADAlertController *)self.queue[childIndex];
                
                //继续遍历队列中的元素
                parentIndex++;
                if (parentIndex >= self.queue.count) {
                    break;
                }
            }
            if ([nextAlertController canShow]) {
                self.currentAlertController = nextAlertController;
                [self insertOperationToShowAlertController];
                
            }
            
        }
    }
}

/// 寻找最佳的孩子下标,若同时有左右孩子,会比较左右孩子的优先级,以及入队列时间,
/// 若左右孩子都不可用,返回父节点下标
/// @param index 父节点下标
- (NSUInteger)fineBestChildIndexWithParentIndex:(NSUInteger)index
{
    //当前 index 的左孩子下标
    NSUInteger lc = LChild(index);
    //当前 index 的右孩子下标
    NSUInteger rc = RChild(index);

    //1.判断当前节点的左右孩子都存在
    if (lc < self.queue.count && rc < self.queue.count) {
        //左右孩子都存在,与下滤操作中一样,取出适合的当父亲节点的那个下标
        id<ADAlertControllerPriorityQueueProtocol> lcObject = self.queue[lc];
        id<ADAlertControllerPriorityQueueProtocol> rcObject = self.queue[rc];
        id<ADAlertControllerPriorityQueueProtocol> properParentObject = self.searchProperParentBlock(lcObject,rcObject);
        return [self.queue indexOfObject:properParentObject];
        
    } else if(lc < self.queue.count){
        //左孩子存在 返回左孩子
        return lc;
    }
    return index;
}

/**
 显示警告框视图,添加到队列中,并执行信号量,防止其他地方再显示
 */
- (void)insertOperationToShowAlertController
{
    if (self.currentAlertController) {
        __weak typeof(self) weakSelf = self;
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            if (weakSelf.currentAlertController) {
                [weakSelf.currentAlertController show];
                //必须将wait 放到最后,会阻塞当前线程的执行
                dispatch_semaphore_wait(weakSelf.semaphore, DISPATCH_TIME_FOREVER);
            }
        }];
        [self.alertOperationQueue cancelAllOperations];
        [self.alertOperationQueue addOperation:blockOperation];
    }
}

#pragma mark - set

- (void)setCurrentAlertController:(ADAlertController *)currentAlertController
{
    if (_currentAlertController != currentAlertController) {
        _currentAlertController = currentAlertController;
        
        __weak ADAlertControllerPriorityQueue *weakSelf = self;
        [_currentAlertController setDidDismissBlock:^(ADAlertController *alertController){
            ///信号量恢复
            dispatch_semaphore_signal(weakSelf.semaphore);
            if (alertController.deleteWhenHiden) {
                if ([ADAlertControllerPriorityQueue getMax] == alertController) {
                    //若当前要隐藏的 alertController 是最前面的,直接执行deleteMax,
                    [ADAlertControllerPriorityQueue deleteMax];
                }else{
                    NSUInteger deleteIndex = [weakSelf.queue indexOfObject:alertController];
                    [ADAlertControllerPriorityQueue deleteAtIndex:deleteIndex];
                }
            }
            weakSelf.currentAlertController = nil;
            //若这里的 showNext ,没成功显示下一个警告框
            //在alertController_viewDidAppear 也有机会去执行
            dispatch_async(dispatch_get_main_queue(), ^{
                //这里异步一下,让控制器转场一下
                [weakSelf showNext];
            });
        }];
    }
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end

@implementation ADAlertControllerPriorityQueue(HeapBehaviour)

+ (void)inset:(id<ADAlertControllerPriorityQueueProtocol>)element
{
    if (element) {
        
        ((NSObject *)element).ad_insertTimeInterval = [[NSDate date] timeIntervalSince1970];
        [[ADAlertControllerPriorityQueue shareInstance].queue addObject:element];
        [[ADAlertControllerPriorityQueue shareInstance] percolateUp:[ADAlertControllerPriorityQueue shareInstance].queue.count - 1];
        
        [[ADAlertControllerPriorityQueue shareInstance] handlerInsertElement:element];
    }
}

+ (id<ADAlertControllerPriorityQueueProtocol>)getMax
{
    return [ADAlertControllerPriorityQueue shareInstance].queue.firstObject;
}

+ (id<ADAlertControllerPriorityQueueProtocol>)deleteMax
{
    if ([ADAlertControllerPriorityQueue shareInstance].queue.count == 0) {
        return nil;
    }
    id firstObject = [ADAlertControllerPriorityQueue shareInstance].queue.firstObject;
    if ([ADAlertControllerPriorityQueue shareInstance].queue.count == 1) {
        [[ADAlertControllerPriorityQueue shareInstance].queue removeLastObject];
    }else{
        id lastObject = [ADAlertControllerPriorityQueue shareInstance].queue.lastObject;
        [[ADAlertControllerPriorityQueue shareInstance].queue removeLastObject];
        [ADAlertControllerPriorityQueue shareInstance].queue[0] = lastObject;
        [[ADAlertControllerPriorityQueue shareInstance] percolateDown:0];
    }
    
    return firstObject;
}

+ (id<ADAlertControllerPriorityQueueProtocol>)deleteAtIndex:(NSUInteger)deleteIndex
{
    if ([ADAlertControllerPriorityQueue shareInstance].queue.count == 0) {
        return nil;
    }
    if (deleteIndex < [ADAlertControllerPriorityQueue shareInstance].queue.count) {
        NSUInteger lastIndex = [ADAlertControllerPriorityQueue shareInstance].queue.count - 1;
        if (deleteIndex != lastIndex) {
            //待删除的下标不是最后一个位置
            //这里就将待删除的下标所在位置用最后一个位置的元素代替,
            //然后删除最后一个元素,再执行下滤操作
            id<ADAlertControllerPriorityQueueProtocol> deleteObject = [ADAlertControllerPriorityQueue shareInstance].queue[deleteIndex];

            id lastObject = [ADAlertControllerPriorityQueue shareInstance].queue.lastObject;
            [ADAlertControllerPriorityQueue shareInstance].queue[deleteIndex] = lastObject;
            [[ADAlertControllerPriorityQueue shareInstance].queue removeLastObject];
            [[ADAlertControllerPriorityQueue shareInstance] percolateDown:deleteIndex];
            return deleteObject;
        }
        else{
            //待删除的就是最后一个位置的元素,直接删除最后一个元素即可
            id<ADAlertControllerPriorityQueueProtocol> deleteObject = [ADAlertControllerPriorityQueue shareInstance].queue[deleteIndex];
            [[ADAlertControllerPriorityQueue shareInstance].queue removeLastObject];
            return deleteObject;
        }
    }
    return nil;
}

#pragma mark - utility

/// 对某个位置的元素进行上滤
/// @param index 开始检查位置
- (NSUInteger)percolateUp:(NSUInteger)index
{
    while ([self parentValid:index]) {
        //只要 index 尚有父亲
        //用 p 表示父亲的下标
        NSUInteger p = Parent(index);
        if (self.parentChildNeedSwapBlock(self.queue[index],self.queue[p],YES)) {
            //父节点不大于子节点,交换之
            [self swap:index second:p];
            index = p;
        }else{
            break;
        }
    }
    return index;
}

/// 从某个位置的下标开始进行下滤
/// @param index 开始下滤位置
- (NSUInteger)percolateDown:(NSUInteger)index
{
    //index 的(至多)两个孩子的下标,用 c 表示
    NSUInteger c = 0;
    while (index != (c = [self properParent:index])) {
        //只要可能的父亲存在,且 index != c,则交换,
        [self swap:index second:c];
        //更新 index,继续下滤
        index = c;
    }
    return index;
}

- (BOOL)parentValid:(NSUInteger)index
{
    return index > 0 && Parent(index) < self.queue.count;
}

- (NSUInteger)properParent:(NSUInteger)index
{
    NSUInteger lc = LChild(index);
    NSUInteger rc = RChild(index);
    if (lc < self.queue.count && rc < self.queue.count) {
        id<ADAlertControllerPriorityQueueProtocol> lcObject = self.queue[lc];
        id<ADAlertControllerPriorityQueueProtocol> rcObject = self.queue[rc];
        id<ADAlertControllerPriorityQueueProtocol> properParentObject = self.searchProperParentBlock(lcObject,rcObject);
        if (self.parentChildNeedSwapBlock(properParentObject,self.queue[index],NO)){
            return [self.queue indexOfObject:properParentObject];
        }
    }
    else if (lc < self.queue.count && self.parentChildNeedSwapBlock(self.queue[lc],self.queue[index],NO)) {
        return lc;
    }
    return index;
}

- (void)swap:(NSUInteger)firstIndex second:(NSUInteger)secondIndex
{
    id<ADAlertControllerPriorityQueueProtocol> firstIndexObject = self.queue[firstIndex];
    id<ADAlertControllerPriorityQueueProtocol> secondIndexObject = self.queue[secondIndex];
    self.queue[firstIndex] = secondIndexObject;
    self.queue[secondIndex] = firstIndexObject;
    
}

@end

@implementation ADAlertControllerPriorityQueue (ADExtention)

+ (void)cleanQueueAllObject{
//    if ([ADAlertControllerPriorityQueue shareInstance].currentAlertController) {
//        [[ADAlertControllerPriorityQueue shareInstance].currentAlertController hiden];
//    }
    [[ADAlertControllerPriorityQueue shareInstance].queue removeAllObjects];
}

@end

@implementation ADAlertController (PriorityQueueExtention)


@end

@implementation UIViewController(ADAlertControllerQueueSupport)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // -> 交换方法
        const NSUInteger count = 2;
        SEL needSwizzleSelectors[count] = {
            @selector(viewDidAppear:),
            @selector(viewDidDisappear:),
        };
        for (int i = 0; i < count;  i++) {
            SEL selector = needSwizzleSelectors[i];
            NSString *newSelectorStr = [NSString stringWithFormat:@"alertController_%@", NSStringFromSelector(selector)];
            Method originMethod = class_getInstanceMethod(self, selector);
            Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

- (void)alertController_viewDidAppear:(BOOL)animated
{
    if ([[ADAlertControllerPriorityQueue shareInstance] checkShowNextValidity]) {
        [[ADAlertControllerPriorityQueue shareInstance] showNext];
    }
    [self alertController_viewDidAppear:animated];
}

- (void)alertController_viewDidDisappear:(BOOL)animated
{
    if ([ADAlertControllerPriorityQueue shareInstance].currentAlertController.targetViewController == self &&
        [ADAlertControllerPriorityQueue shareInstance].currentAlertController.autoHidenWhenTargetViewControllerDisappear) {
        [ADAlertControllerPriorityQueue shareInstance].currentAlertController.deleteWhenHiden = NO;
        [[ADAlertControllerPriorityQueue shareInstance].currentAlertController hiden];
    }
    else if ([[ADAlertControllerPriorityQueue shareInstance] checkShowNextValidity]) {
        [[ADAlertControllerPriorityQueue shareInstance] showNext];
    };
    [self alertController_viewDidDisappear:animated];
}

+ (BOOL)isShowBlackListController
{
    UIViewController *topVisibleVC = [UIViewController ad_topVisibleViewController];
    NSArray *blackList = ADAlertController.blackClassList;
    for (Class class in blackList) {
        if ([topVisibleVC isKindOfClass:class]) {
            return YES;
        }
    }
    return NO;
}
@end

@implementation NSObject (ADPriorityQueueExtention)

- (void)setAd_insertTimeInterval:(NSTimeInterval)ad_insertTimeInterval
{
    objc_setAssociatedObject(self, @selector(ad_insertTimeInterval), @(ad_insertTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)ad_insertTimeInterval
{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}
@end
