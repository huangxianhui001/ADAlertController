//
//  ADPickerView.m
//  ADAlertController
//
//  Created by Alan on 2020/2/5.
//  Copyright © 2020 Alan. All rights reserved.
//

#import "ADPickerView.h"
#import "ADAlertController.h"

@interface ADPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewHeight;
@end

@implementation ADPickerView
@synthesize alertController;

+ (instancetype)pickerViewWithTitle:(NSString *)title datasource:(id<ADPickerViewDatasource>)datasource
{
    ADPickerView *pickerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    pickerView.titleLab.text = title;
    pickerView.pickerViewDatasource = datasource;
    return pickerView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    [self.cancelBtn addTarget:self action:@selector(hiden) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn addTarget:self action:@selector(onSureAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)onSureAction
{
    if (self.onSureCallback) {
        self.onSureCallback(self.firstColSelectRowIndex, self.secondColSelectRowIndex, self.thirdColSelectRowIndex);
    }
    [self hiden];
}

#pragma mark - ADCustomAlertContentViewProtocol

- (void)show
{
    ADAlertControllerConfiguration *config = [ADAlertControllerConfiguration defaultConfigurationWithPreferredStyle:ADAlertControllerStyleSheet];
    config.hidenWhenTapBackground = YES;
    
    ADAlertController *alertViewController = [[ADAlertController alloc] initWithOptions:config title:nil message:nil actions:nil];
    
    alertViewController.contentView = self;
    [self.heightAnchor constraintEqualToConstant:self.contentViewHeight].active = YES;
    
    [alertViewController show];
    self.alertController = alertViewController;
    
    if (self.needAutoScrollToPreviouSelectIndex) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.firstColSelectRowIndex = MAX(0, self.firstColSelectRowIndex);
            self.secondColSelectRowIndex = MAX(0, self.secondColSelectRowIndex);
            self.thirdColSelectRowIndex = MAX(0, self.thirdColSelectRowIndex);
            
            [self.pickerView selectRow:self.firstColSelectRowIndex inComponent:0 animated:YES];
            
            [self.pickerView reloadAllComponents];
            if ([self.pickerViewDatasource numberOfComponentsInPickerView:self] == 3) {
                if (self.secondColSelectRowIndex != NSNotFound) {
                    [self.pickerView selectRow:self.secondColSelectRowIndex inComponent:1 animated:YES];
                }
                if (self.thirdColSelectRowIndex != NSNotFound) {
                    [self.pickerView selectRow:self.thirdColSelectRowIndex inComponent:2 animated:YES];
                }
            }else if([self.pickerViewDatasource numberOfComponentsInPickerView:self] == 2){
                if (self.secondColSelectRowIndex != NSNotFound) {
                    [self.pickerView selectRow:self.secondColSelectRowIndex inComponent:1 animated:YES];
                }
            }
            
        });
        
    }else{
        self.firstColSelectRowIndex = 0;
        self.secondColSelectRowIndex = 0;
        self.thirdColSelectRowIndex = 0;
    }
}

- (void)hiden
{
    [self.alertController hiden];
}

- (CGFloat)contentViewHeight{
    if (@available(iOS 11.0, *)) {
        return _topViewHeight.constant + _pickerViewHeight.constant + [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }else{
        return  _topViewHeight.constant + _pickerViewHeight.constant;
    }
}

- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    return [self.pickerView selectedRowInComponent:component];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.pickerViewDatasource numberOfComponentsInPickerView:self];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerViewDatasource pickerView:self numberOfRowsInComponent:component];
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.pickerView.bounds.size.width / [self.pickerViewDatasource numberOfComponentsInPickerView:self];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
    }
    NSString *title = [self.pickerViewDatasource pickerView:self titleForRow:row forComponent:component];
    UIColor *titleColor = nil;
    if (component == 0) {
        titleColor = row == self.firstColSelectRowIndex ? [UIColor blueColor] : [UIColor grayColor];
    }else if (component == 1) {
        titleColor = row == self.secondColSelectRowIndex ? [UIColor blueColor] : [UIColor grayColor];
    }else if (component == 2) {
        titleColor = row == self.thirdColSelectRowIndex ? [UIColor blueColor] : [UIColor grayColor];
    }
    label.textColor = titleColor;
    label.text = title;
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:self didSelectRow:row inComponent:component];
    }
    if (component == 0) {
        self.firstColSelectRowIndex = row;
        self.secondColSelectRowIndex = 0;
        self.thirdColSelectRowIndex = 0;
        
        [self.pickerView reloadAllComponents];
        if ([self.pickerViewDatasource numberOfComponentsInPickerView:self] == 3) {
            [self.pickerView selectRow:self.secondColSelectRowIndex inComponent:1 animated:YES];
            [self.pickerView selectRow:self.thirdColSelectRowIndex inComponent:2 animated:YES];
        }else if([self.pickerViewDatasource numberOfComponentsInPickerView:self] == 2){
            [self.pickerView selectRow:self.secondColSelectRowIndex inComponent:1 animated:YES];
        }
        
    }else if(component == 1){
        self.secondColSelectRowIndex = row;
         self.thirdColSelectRowIndex = 0;
        
        [self.pickerView reloadComponent:1];
        if ([self.pickerViewDatasource numberOfComponentsInPickerView:self] == 3) {
            [self.pickerView reloadComponent:2];
            [self.pickerView selectRow:self.thirdColSelectRowIndex inComponent:2 animated:YES];
        }
    }else{
         self.thirdColSelectRowIndex = row;
        [self.pickerView reloadComponent:2];

    }
}
@end
