//
//  ADAdvertView.m
//  ADAlertController
//
//  Created by Alan on 2020/2/3.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADAdvertView.h"
#import "ADAlertController.h"
#import "UIView+ADAlertControllerAdditions.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define kRandomColor    RGBCOLOR((arc4random()%255),(arc4random()%255),(arc4random()%255))

@interface ADAdvertView ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (weak, nonatomic,readwrite) id<ADAdvertViewDelegate> delegate;
@property (nonatomic, strong,readwrite) NSArray *advertDataList;

@property (assign, nonatomic) CGFloat maxWidth;
@property (assign, nonatomic) CGFloat imageViewHeight;
@property (assign, nonatomic) NSUInteger currentPage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeBtnHeight;
@end

@implementation ADAdvertView

@synthesize alertController;
@dynamic contentViewHeight;

+ (instancetype)advertViewWithDelegate:(id<ADAdvertViewDelegate>)delegate dataArray:(NSArray *)dataArray
{
    ADAdvertView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    view.delegate = delegate;
    view.maxWidth = [UIScreen mainScreen].bounds.size.width - 60;
    view.imageViewHeight = view.maxWidth * 400/295.0;
    view.containerViewHeight.constant = view.imageViewHeight;
    view.advertDataList = dataArray;
    return view;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.pageControl.hidesForSinglePage = YES;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.containerView addSubview:self.scrollView];
    [self.scrollView ad_pinEdgesToSuperviewEdges];
    self.scrollView.delegate = self;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;

    [self.closeBtn addTarget:self
                      action:@selector(onCloseAction)
            forControlEvents:UIControlEventTouchUpInside];
}

- (void) onCloseAction
{
    [self.alertController hiden];
}

- (void)setAdvertDataList:(NSArray *)advertDataList
{
    if (advertDataList.count == 0) {
        return;
    }
    _advertDataList = advertDataList;
    UIImageView *leftView = nil;
    NSLayoutConstraint *left = nil;
    
    for (int i = 0; i < advertDataList.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.tag = 100 + i;
        imageView.backgroundColor = kRandomColor;
        [self.scrollView addSubview:imageView];
        
        //添加点击事件
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGestureAction:)];
        gesture.numberOfTouchesRequired = 1;
        gesture.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:gesture];
        
        //添加约束
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageView.superview attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
        
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:imageView.superview attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        if (!leftView) {
             left = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:imageView.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        }else{
             left = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
        }

        [self.scrollView addConstraint:left];
        [self.scrollView addConstraint:top];
        [self.scrollView addConstraint:width];
        [self.scrollView addConstraint:height];
        
        if (i == advertDataList.count - 1) {
            NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:imageView.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
            [self.scrollView addConstraint:right];
        }
        
        leftView = imageView;
    }
    
    self.pageControl.numberOfPages = advertDataList.count;
    
}

- (void)onTapGestureAction:(UITapGestureRecognizer *)sender
{
    NSUInteger index = sender.view.tag - 100;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(advertView:didSelectItemAtIndex:)]) {
        [self.delegate advertView:self didSelectItemAtIndex:index];
    }
    [self.alertController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ADCustomAlertContentViewProtocol

- (void)show
{
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleAlert];
    config.alertViewCornerRadius = 0;
    config.alertContainerViewBackgroundColor = [UIColor clearColor];
    
    ADAlertController *alertController = [[ADAlertController alloc]initWithOptions:config title:nil message:nil actions:nil];
    alertController.maximumWidth = self.maxWidth;
   
    alertController.alertViewContentView = self;
    [self.heightAnchor constraintEqualToConstant:self.contentViewHeight].active = YES;
    self.alertController = alertController;
    
    [alertController show];
    
}

- (void)hiden
{
    [self.alertController hiden];
}

- (CGFloat)contentViewHeight
{
    return self.containerViewHeight.constant + self.pageControlHeight.constant + self.closeBtnHeight.constant;
}

#pragma mark - scrollviewdelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    self.currentPage = offset.x / self.maxWidth;
    [self.pageControl setCurrentPage:self.currentPage];
    [self.pageControl updateCurrentPageDisplay];
}



@end
