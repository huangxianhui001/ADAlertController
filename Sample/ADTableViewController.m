//
//  ADTableViewController.m
//  ADAlertController
//
//  Created by Alan on 2020/2/2.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADTableViewController.h"
#import "ADTableViewData.h"
#import "ADAlertController.h"
#import <MapKit/MapKit.h>
#import "ADAdvertView.h"
#import "ADPickerView.h"

@interface ADTableViewController ()
@property (nonatomic, strong) NSArray<ADTableViewData *> *datasource;

@property (weak, nonatomic) ADAlertController *alertController;
@property (weak, nonatomic) ADAlertAction *sureAction;

@property (nonatomic, strong) NSArray<NSString *> *yearDatasource;
@property (nonatomic, strong) NSArray<NSString *> *monthDatasource;
@property (nonatomic, assign) NSUInteger selectYearIndex;
@property (nonatomic, assign) NSUInteger selectMonthIndex;
@end

@interface ADTableViewController (TextFieldDelegate)<UITextFieldDelegate>

@end

@interface ADTableViewController(AdvertViewDelegate)<ADAdvertViewDelegate>

@end

@interface ADTableViewController (PickerViewDatasource)<ADPickerViewDatasource>

@end

@implementation ADTableViewController (TextFieldDelegate)

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.alertController && [self.alertController.textFields containsObject:textField]) {
        if ([string isEqualToString:@""]) {
            BOOL firstTextFieldEnbale = self.alertController.textFields.firstObject.text.length > 0;
            BOOL lastTextFieldEnable = self.alertController.textFields.lastObject.text.length > 0;;
            if (self.alertController.textFields.firstObject == textField) {
                firstTextFieldEnbale = textField.text.length - range.length > 0;
            }else if (self.alertController.textFields.lastObject == textField){
                lastTextFieldEnable = textField.text.length - range.length > 0;
            }
            self.sureAction.enabled = firstTextFieldEnbale && lastTextFieldEnable;
        }else {
            BOOL firstTextFieldEnbale = self.alertController.textFields.firstObject.text.length > 0;
            BOOL lastTextFieldEnable = self.alertController.textFields.lastObject.text.length > 0;;
            if (self.alertController.textFields.firstObject == textField) {
                firstTextFieldEnbale |= string.length > 0;
            }else if (self.alertController.textFields.lastObject == textField){
                lastTextFieldEnable |= string.length > 0;
            }
            self.sureAction.enabled = firstTextFieldEnbale && lastTextFieldEnable;
        }
    }
    return YES;
}

@end

@implementation ADTableViewController(AdvertViewDelegate)

- (void)advertView:(ADAdvertView *)view didSelectItemAtIndex:(NSUInteger)index
{
    NSLog(@"点击了第%lu个广告",(unsigned long)index + 1);
}

@end

@implementation ADTableViewController(PickerViewDatasource)

- (NSInteger)numberOfComponentsInPickerView:(ADPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(ADPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.yearDatasource.count;
            break;
        case 1:
            return self.monthDatasource.count;
        default:
            return 0;
    }
}

- (NSString *)pickerView:(ADPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.yearDatasource[row];
        case 1:
            return self.monthDatasource[row];
        default:
            return nil;
    }
}
@end

@implementation ADTableViewController

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.datasource[indexPath.row].title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ADTableViewData *data = self.datasource[indexPath.row];
    SEL selector = NSSelectorFromString(data.selector);
    [self performSelector:selector onThread:NSThread.mainThread withObject:nil waitUntilDone:NO];
}

#pragma mark - sample

- (void)alertStyleTitleOnly
{
    ADAlertAction *cancelAction = [ADAlertAction actionWithTitle:@"取消" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    ADAlertAction *sureAction = [ADAlertAction actionWithTitle:@"确定" style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了确定");
    }];
    
    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:nil title:@"这里是标题" message:nil actions:@[cancelAction,sureAction]];
    [alertView show];
    
}

- (void)alertStyleMessageOnly
{
    ADAlertAction *cancelAction = [ADAlertAction actionWithTitle:@"取消" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    ADAlertAction *sureAction = [ADAlertAction actionWithTitle:@"确定" style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了确定");
    }];
    
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleAlert];
    config.showsSeparators = YES;
    config.messageTextInset = UIEdgeInsetsMake(20, 10, 20, 10);
//    config.alwaysArrangesActionButtonsVertically = YES;
    
    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:nil message:@"这里是详细消息内容,ADAlertControllerConfiguration中可以配置是否在多个按钮间显示分割线" actions:@[cancelAction,sureAction]];
    [alertView show];
}

- (void)alertStyleTitleAndMessage
{
    ADAlertAction *cancelAction = [ADAlertAction actionWithTitle:@"取消" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    ADAlertAction *sureAction = [ADAlertAction actionWithTitle:@"确定" style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了确定");
    }];
    
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleAlert];
    config.showsSeparators = YES;
    config.messageTextInset = UIEdgeInsetsMake(0, 10, 20, 10);
    config.titleTextColor = [UIColor blackColor];
    config.messageTextColor = [UIColor grayColor];
    
    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"这里是标题" message:@"这里是详细消息内容,ADAlertControllerConfiguration中可以配置更多内容" actions:@[cancelAction,sureAction]];
    [alertView show];
}

- (void)alertStylePanEnable
{
    ADAlertAction *cancelAction = [ADAlertAction actionWithTitle:@"取消" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    ADAlertAction *sureAction = [ADAlertAction actionWithTitle:@"确定" style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了确定");
    }];
    
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleAlert];
    config.showsSeparators = YES;
    config.messageTextInset = UIEdgeInsetsMake(0, 10, 20, 10);
    config.titleTextColor = [UIColor blackColor];
    config.messageTextColor = [UIColor grayColor];
    
    config.swipeDismissalGestureEnabled = YES;
    
    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"这里是标题" message:@"当swipeDismissalGestureEnabled==YES时,将手指放到警告框内,除了按钮元素之外的任何 UI 元素,可以上下拖动关闭警告框" actions:@[cancelAction,sureAction]];
    
    [alertView show];
}

- (void)alertStyleCustomContentView
{
    ADAlertAction *cancelAction = [ADAlertAction actionWithTitle:@"取消" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    ADAlertAction *sureAction = [ADAlertAction actionWithTitle:@"确定" style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了确定");
    }];
    
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleAlert];
    config.showsSeparators = YES;
    config.messageTextInset = UIEdgeInsetsMake(0, 10, 20, 10);

    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"这里是标题" message:@"可以将alertViewContentView属性赋值任何 UIView 子类对象,唯一要求是该子类 view 对象需要自己提供高度约束" actions:@[cancelAction,sureAction]];
    
    //添加自定义视图
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    alertView.alertViewContentView = mapView;
    //须提供高度约束
    [mapView.heightAnchor constraintEqualToConstant:250].active = YES;
    
    [alertView show];
}

- (void)alertStyleLongMessage
{
    ADAlertAction *cancelAction = [ADAlertAction actionWithTitle:@"不同意" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了不同意");
    }];
    
    ADAlertAction *sureAction = [ADAlertAction actionWithTitle:@"同意" style:ADActionStyleDestructive handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了同意");
    }];
    
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleAlert];
    config.showsSeparators = YES;
    config.messageTextInset = UIEdgeInsetsMake(0, 10, 20, 10);
    config.messageFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    config.titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    config.messageTextColor = [UIColor grayColor];
    
    NSString *message = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    
    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"隐私政策已更新,请查看以下内容" message:message actions:@[cancelAction,sureAction]];

    [alertView show];
   
}

- (void)alertStyleMultipButton
{
    ADAlertActionConfiguration *actionConfig = [ADAlertActionConfiguration defaultConfigurationWithActionStyle:ADActionStyleDefault];
    actionConfig.titleColor = [UIColor blueColor];
    
    ADAlertAction *action1 = [ADAlertAction actionWithTitle:@"WiFi 或者 移动网络" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"选择了WiFi 或者 移动网络");
    } configuration:actionConfig];
    
    ADAlertAction *action2 = [ADAlertAction actionWithTitle:@"移动网络" style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"选择了移动网络");
    } configuration:actionConfig];
    
    ADAlertAction *action3 = [ADAlertAction actionWithTitle:@"WiFi" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"选择了WiFi");
    } configuration:actionConfig];
    
    ADAlertAction *action4 = [ADAlertAction actionWithTitle:@"不允许网络访问" style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"选择了不允许网络访问");
    } configuration:actionConfig];
    
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleAlert];
    config.showsSeparators = YES;
    
    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"请选择该 APP 允许访问的网络类型" message:nil actions:@[action1,action2,action3,action4]];

    [alertView show];
   
}

- (void)alertStyleImageButton
{
    ADAlertAction *action1 = [ADAlertAction actionWithImage:[UIImage imageNamed:@"share_1"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertAction *action2 = [ADAlertAction actionWithImage:[UIImage imageNamed:@"share_2"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertAction *action3 = [ADAlertAction actionWithImage:[UIImage imageNamed:@"share_3"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertAction *action4 = [ADAlertAction actionWithImage:[UIImage imageNamed:@"share_4"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertAction *action5 = [ADAlertAction actionWithImage:[UIImage imageNamed:@"share_5"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleAlert];
    config.showsSeparators = YES;
    
    
    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"这里是标题" message:nil actions:@[action1,action2,action3,action4,action5]];

    [alertView show];
   
}

- (void)alertStyleGroupButtons
{
    ADAlertActionConfiguration *actionConfig = [ADAlertActionConfiguration defaultConfigurationWithActionStyle:ADActionStyleDefault];
    actionConfig.titleColor = [UIColor blueColor];
    
    ADAlertAction *action1 = [ADAlertAction actionWithImage:[UIImage imageNamed:@"share_1"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertAction *action2 = [ADAlertAction actionWithImage:[UIImage imageNamed:@"share_2"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertAction *action3 = [ADAlertAction actionWithImage:[UIImage imageNamed:@"share_3"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertAction *action4 = [ADAlertAction actionWithImage:[UIImage imageNamed:@"share_4"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertAction *action5 = [ADAlertAction actionWithTitle:@"短信" style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    ADAlertGroupAction *group = [ADAlertGroupAction groupActionWithActions:@[action1,action2,action3,action4,action5]];
    
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleAlert];
    config.showsSeparators = YES;
    
    
    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"ADAlertGroupAction" message:@"一个ADAlertGroupAction会被当做一个ADAlertAction对待,且内部的按钮会被等分宽度" actions:@[group]];

    [alertView show];
   
}

- (void)alertStyleImageAction
{
    ADAlertImageAction *action1 = [ADAlertImageAction actionWithTitle:@"QQ" image:[UIImage imageNamed:@"share_1"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertImageAction *action2 = [ADAlertImageAction actionWithTitle:@"QQ空间" image:[UIImage imageNamed:@"share_2"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertImageAction *action3 = [ADAlertImageAction actionWithTitle:@"短信" image:[UIImage imageNamed:@"share_3"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertImageAction *action4 = [ADAlertImageAction actionWithTitle:@"朋友圈" image:[UIImage imageNamed:@"share_4"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertImageAction *action5 = [ADAlertImageAction actionWithTitle:@"微信好友" image:[UIImage imageNamed:@"share_5"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertGroupAction *group = [ADAlertGroupAction groupActionWithActions:@[action1,action2,action3,action4,action5]];

    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleAlert];
    config.showsSeparators = YES;
    
    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"请选择分享方式" message:nil actions:@[group]];

    [alertView show];
   
}

- (void)alertStyleTextField
{
    ADAlertAction *cancelAction = [ADAlertAction actionWithTitle:@"取消" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    ADAlertAction *sureAction = [ADAlertAction actionWithTitle:@"确定" style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了确定");
    }];
    sureAction.enabled = NO;
    
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleAlert];
    config.showsSeparators = YES;
    config.messageTextInset = UIEdgeInsetsMake(0, 10, 20, 10);
    config.titleTextColor = [UIColor blackColor];
    config.messageTextColor = [UIColor grayColor];
    
    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"这里是标题" message:@"这里是详细消息内容" actions:@[cancelAction,sureAction]];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField * _Nullable textField) {
        textField.placeholder = @"请输入用户名";
        textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        textField.delegate = self;
        
    }];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField * _Nullable textField) {
        textField.secureTextEntry = YES;
        textField.placeholder = @"请输入密码";
        textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        textField.delegate = self;

    }];
    self.alertController = alertView;
    self.sureAction = sureAction;
    [alertView show];
}

- (void)alertStyleCustomContentViewOnly
{
    ADAdvertView *advertView = [ADAdvertView advertViewWithDelegate:self dataArray:@[@"1",@"2"]];
    [advertView show];
    
}

- (void)actionSheetStyleTitleOnly
{
    ADAlertAction *cancelAction = [ADAlertAction actionWithTitle:@"取消" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleActionSheet];
    
    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"这里是标题" message:nil actions:nil];
    //actionSheet 的取消按钮,需要这样设置
    [alertView addActionSheetCancelAction:cancelAction];
    
    [alertView show];
}

- (void)actionSheetStyleTitleAndMessage
{
    ADAlertAction *cancelAction = [ADAlertAction actionWithTitle:@"取消" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleActionSheet];
    config.messageTextInset = UIEdgeInsetsMake(0, 10, 20, 10);
    
    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"这里是标题" message:@"这里是内容,内容同样可以配置字体和字体颜色,以及长文本" actions:nil];
    //actionSheet 的取消按钮,需要这样设置
    [alertView addActionSheetCancelAction:cancelAction];
    
    [alertView show];
}

- (void)actionSheetStyleCustomContentView
{
    ADAlertAction *cancelAction = [ADAlertAction actionWithTitle:@"取消" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    ADAlertAction *sureAction = [ADAlertAction actionWithTitle:@"确定" style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了确定");
    }];
    
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleActionSheet];
    config.showsSeparators = YES;
    config.messageTextInset = UIEdgeInsetsMake(0, 10, 20, 10);

    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"这里是标题" message:@"可以将alertViewContentView属性赋值任何 UIView 子类对象,唯一要求是该子类 view 对象需要自己提供高度约束" actions:@[sureAction]];
    
    //添加自定义视图
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    alertView.alertViewContentView = mapView;
    //须提供高度约束
    [mapView.heightAnchor constraintEqualToConstant:250].active = YES;
    
    [alertView addActionSheetCancelAction:cancelAction];

    [alertView show];
}

- (void)actionSheetStyleMultipButton
{
    ADAlertAction *action1 = [ADAlertAction actionWithTitle:@"添加" style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"选择了添加");
    }];
    
    ADAlertAction *action2 = [ADAlertAction actionWithTitle:@"编辑" style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"选择了编辑");
    }];
    
    ADAlertAction *action3 = [ADAlertAction actionWithTitle:@"删除" style:ADActionStyleDestructive handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"选择了删除");
    }];
    
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleActionSheet];
    config.showsSeparators = YES;
    
    
    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"请选择操作类型" message:nil actions:@[action1,action2,action3]];

     ADAlertAction *cancelAction = [ADAlertAction actionWithTitle:@"取消" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
           NSLog(@"点击了取消");
       }];
    [alertView addActionSheetCancelAction:cancelAction];
    
    [alertView show];
   
}

- (void)actionSheetStyleImageButton
{
    ADAlertAction *action1 = [ADAlertAction actionWithImage:[UIImage imageNamed:@"share_1"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertAction *action2 = [ADAlertAction actionWithImage:[UIImage imageNamed:@"share_2"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertAction *action3 = [ADAlertAction actionWithImage:[UIImage imageNamed:@"share_3"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertAction *action4 = [ADAlertAction actionWithImage:[UIImage imageNamed:@"share_4"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertAction *action5 = [ADAlertAction actionWithImage:[UIImage imageNamed:@"share_5"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleActionSheet];
    config.showsSeparators = YES;
    
    
    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"分享类型" message:nil actions:@[action1,action2,action3,action4,action5]];
    
    ADAlertAction *cancelAction = [ADAlertAction actionWithTitle:@"取消" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    [alertView addActionSheetCancelAction:cancelAction];
    
    [alertView show];
   
}

- (void)actionSheetStyleGroupButton
{
    ADAlertImageAction *action1 = [ADAlertImageAction actionWithTitle:@"QQ" image:[UIImage imageNamed:@"share_1"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertImageAction *action2 = [ADAlertImageAction actionWithTitle:@"QQ空间" image:[UIImage imageNamed:@"share_2"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertImageAction *action3 = [ADAlertImageAction actionWithTitle:@"短信" image:[UIImage imageNamed:@"share_3"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertImageAction *action4 = [ADAlertImageAction actionWithTitle:@"朋友圈" image:[UIImage imageNamed:@"share_4"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertImageAction *action5 = [ADAlertImageAction actionWithTitle:@"微信好友" image:[UIImage imageNamed:@"share_5"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertGroupAction *group = [ADAlertGroupAction groupActionWithActions:@[action1,action2,action3,action4,action5]];

    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleActionSheet];
    config.showsSeparators = YES;
    
    
    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"分享类型" message:nil actions:@[group]];
    
    ADAlertAction *cancelAction = [ADAlertAction actionWithTitle:@"取消" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    [alertView addActionSheetCancelAction:cancelAction];
    
    [alertView show];
   
}

- (void)actionSheetStyleScrollableButton
{
    ADAlertImageAction *action1 = [ADAlertImageAction actionWithTitle:@"QQ" image:[UIImage imageNamed:@"share_1"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertImageAction *action2 = [ADAlertImageAction actionWithTitle:@"QQ空间" image:[UIImage imageNamed:@"share_2"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertImageAction *action3 = [ADAlertImageAction actionWithTitle:@"短信" image:[UIImage imageNamed:@"share_3"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertImageAction *action4 = [ADAlertImageAction actionWithTitle:@"朋友圈" image:[UIImage imageNamed:@"share_4"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertImageAction *action5 = [ADAlertImageAction actionWithTitle:@"微信好友" image:[UIImage imageNamed:@"share_5"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertImageAction *action6 = [ADAlertImageAction actionWithTitle:@"微博" image:[UIImage imageNamed:@"share_1"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADAlertImageAction *action7 = [ADAlertImageAction actionWithTitle:@"支付宝" image:[UIImage imageNamed:@"share_2"] style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        
    }];
    
    ADScrollableGroupAction *group = [ADScrollableGroupAction scrollableGroupActionWithActionWidth:100 actions:@[action1,action2,action3,action4,action5,action6,action7]];

    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleActionSheet];
    config.showsSeparators = YES;
    config.messageTextInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"分享" message:@"左右滑动查看更多分享类型" actions:@[group]];
    
    ADAlertAction *cancelAction = [ADAlertAction actionWithTitle:@"取消" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    [alertView addActionSheetCancelAction:cancelAction];
    
    [alertView show];
   
}

- (void)sheetStyle
{
    ADAlertAction *cancelAction = [ADAlertAction actionWithTitle:@"取消" style:ADActionStyleCancel handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    ADAlertAction *sureAction = [ADAlertAction actionWithTitle:@"确定" style:ADActionStyleDefault handler:^(__kindof ADAlertAction * _Nonnull action) {
        NSLog(@"点击了确定");
    }];
    
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleSheet];
    config.showsSeparators = YES;
    config.messageTextInset = UIEdgeInsetsMake(0, 10, 20, 10);

    ADAlertController *alertView = [[ADAlertController alloc] initWithOptions:config title:@"这里是标题" message:@"ADAlertControllerStyleSheet是底部和左右边距都为 0 的 ActionSheet 风格" actions:@[sureAction]];
    
    //添加自定义视图
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    alertView.alertViewContentView = mapView;
    //须提供高度约束
    [mapView.heightAnchor constraintEqualToConstant:250].active = YES;
    
    [alertView addActionSheetCancelAction:cancelAction];

    [alertView show];
}

- (void)sheetStyleSample
{
    ADPickerView *pickerView = [ADPickerView pickerViewWithTitle:@"请选择出生年月" datasource:self];
    pickerView.firstColSelectRowIndex = self.selectYearIndex;
    pickerView.secondColSelectRowIndex = self.selectMonthIndex;
    pickerView.needAutoScrollToPreviouSelectIndex = YES;
    
    __weak typeof(self)weakself = self;
    pickerView.onSureCallback = ^(NSUInteger firstColSelectRowIndex, NSUInteger secondColSelectRowIndex, NSUInteger thirdColSelectRowIndex) {
        weakself.selectYearIndex = firstColSelectRowIndex;
        weakself.selectMonthIndex = secondColSelectRowIndex;
        NSLog(@"您选择的出生年月是%@ %@",weakself.yearDatasource[firstColSelectRowIndex],weakself.monthDatasource[secondColSelectRowIndex]);
        
    };
    
    [pickerView show];
    
}

#pragma mark - get
- (NSArray<ADTableViewData *> *)datasource
{
    if (!_datasource) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:10];
        //1
        ADTableViewData *data = [ADTableViewData dataWithTitle:@"仅标题的警告框" selector:NSStringFromSelector(@selector(alertStyleTitleOnly))];
        [temp addObject:data];
        //2.
        data = [ADTableViewData dataWithTitle:@"仅内容的警告框" selector:NSStringFromSelector(@selector(alertStyleMessageOnly))];
        [temp addObject:data];
        //3.
        data = [ADTableViewData dataWithTitle:@"同时包含标题内容的警告框" selector:NSStringFromSelector(@selector(alertStyleTitleAndMessage))];
        [temp addObject:data];
        //4.
        data = [ADTableViewData dataWithTitle:@"内容视图可上下拖动的警告框" selector:NSStringFromSelector(@selector(alertStylePanEnable))];
        [temp addObject:data];
        //5.
        data = [ADTableViewData dataWithTitle:@"添加自定义视图的警告框" selector:NSStringFromSelector(@selector(alertStyleCustomContentView))];
        [temp addObject:data];
        //6.
        data = [ADTableViewData dataWithTitle:@"详细内容为长文本时自动滚动的警告框" selector:NSStringFromSelector(@selector(alertStyleLongMessage))];
        [temp addObject:data];
        //7.
        data = [ADTableViewData dataWithTitle:@"可包含多个按钮的警告框" selector:NSStringFromSelector(@selector(alertStyleMultipButton))];
        [temp addObject:data];
        //8.
        data = [ADTableViewData dataWithTitle:@"可包含多个图片按钮的警告框" selector:NSStringFromSelector(@selector(alertStyleImageButton))];
        [temp addObject:data];
        //9.
        data = [ADTableViewData dataWithTitle:@"分组按钮的警告框" selector:NSStringFromSelector(@selector(alertStyleGroupButtons))];
        [temp addObject:data];
        //10.
        data = [ADTableViewData dataWithTitle:@"另一种布局的AlertAction的警告框" selector:NSStringFromSelector(@selector(alertStyleImageAction))];
        [temp addObject:data];
        //11.
        data = [ADTableViewData dataWithTitle:@"添加输入框的警告框" selector:NSStringFromSelector(@selector(alertStyleTextField))];
        [temp addObject:data];
        //12.
        data = [ADTableViewData dataWithTitle:@"仅显示自定义视图的警告框" selector:NSStringFromSelector(@selector(alertStyleCustomContentViewOnly))];
        [temp addObject:data];
        //13.
        data = [ADTableViewData dataWithTitle:@"仅标题的ActionSheet" selector:NSStringFromSelector(@selector(actionSheetStyleTitleOnly))];
        [temp addObject:data];
        //14.
        data = [ADTableViewData dataWithTitle:@"包含标题和内容的ActionSheet" selector:NSStringFromSelector(@selector(actionSheetStyleTitleAndMessage))];
        [temp addObject:data];
        //15.
        data = [ADTableViewData dataWithTitle:@"添加自定义视图的ActionSheet" selector:NSStringFromSelector(@selector(actionSheetStyleCustomContentView))];
        [temp addObject:data];
        //16.
        data = [ADTableViewData dataWithTitle:@"包含多个按钮的ActionSheet" selector:NSStringFromSelector(@selector(actionSheetStyleMultipButton))];
               [temp addObject:data];
               
        //17
        data = [ADTableViewData dataWithTitle:@"包含多个图片按钮的ActionSheet" selector:NSStringFromSelector(@selector(actionSheetStyleImageButton))];
        [temp addObject:data];
        //18
        data = [ADTableViewData dataWithTitle:@"分组按钮的ActionSheet" selector:NSStringFromSelector(@selector(actionSheetStyleGroupButton))];
        [temp addObject:data];
        //19.
        data = [ADTableViewData dataWithTitle:@"分组可滑动的ActionSheet" selector:NSStringFromSelector(@selector(actionSheetStyleScrollableButton))];
        [temp addObject:data];
        //20.
        data = [ADTableViewData dataWithTitle:@"无边距风格的ActionSheet" selector:NSStringFromSelector(@selector(sheetStyle))];
        [temp addObject:data];
        //21.
        data = [ADTableViewData dataWithTitle:@"无边距风格的ActionSheet的应用" selector:NSStringFromSelector(@selector(sheetStyleSample))];
        [temp addObject:data];
        
        _datasource = [temp copy];
    }return _datasource;
}

- (NSArray<NSString *> *)yearDatasource
{
    if (!_yearDatasource) {
        NSInteger thisYear = [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]] year];
        NSInteger beginYear = 1970;
        NSInteger count = thisYear - beginYear;
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:count];
        for (NSInteger i = beginYear; i <= thisYear; i++) {
            [temp addObject:[NSString stringWithFormat:@"%ld 年",i]];
        }
        _yearDatasource = [temp copy];
    }
    return _yearDatasource;
}

- (NSArray<NSString *> *)monthDatasource
{
    if (!_monthDatasource) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:12];
        for (int i = 1; i <= 12; i++) {
            [temp addObject:[NSString stringWithFormat:@"%d 月",i]];
        }
        _monthDatasource = [temp copy];
    }return _monthDatasource;
}
@end

