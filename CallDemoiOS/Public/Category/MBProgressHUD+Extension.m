//
//  MBProgressHUD+Extension.m
//  Caocao
//
//  Created by wanghaipeng on 2018/3/15.
//  Copyright © 2018年 wanghaipeng. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

// 当前系统版本号
#define DeviceVersion ([UIDevice currentDevice].systemVersion.floatValue)
#define FontPingFangRegular (DeviceVersion >= 9.0) ? @"PingFangSC-Semibold" : @"Helvetica"

#define kWhiteColor [UIColor whiteColor]
#define kBlackColor [UIColor blackColor]

@implementation MBProgressHUD (Extension)

// 文本hud
+ (void)showHUDWith:(NSString *)text view:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    hud.label.font = [UIFont fontWithName:FontPingFangRegular size:14.0];
    hud.label.textColor = kWhiteColor;
    hud.bezelView.backgroundColor = kBlackColor;
    [hud hide];
}


// 设置菊花模式
- (void)setHUDModeToIndeterminate
{
    self.mode = MBProgressHUDModeIndeterminate;
    self.backgroundView.alpha = 0.3;
    self.backgroundView.backgroundColor = kBlackColor;
    self.bezelView.backgroundColor = kBlackColor;
}

// 设置文本模式
- (void)setHUDModeToText:(NSString *)text
{
    self.mode = MBProgressHUDModeText;
    self.label.text = text;
    self.label.numberOfLines = 0;
    self.label.font = [UIFont fontWithName:FontPingFangRegular size:14.0];
    self.label.textColor = kWhiteColor;
    self.bezelView.backgroundColor = kBlackColor;
}

// 设置菊花图文模式
- (void)setHUDModeToIndeterminateWithText:(NSString *)text
{
    self.mode = MBProgressHUDModeIndeterminate;
    self.label.text = text;
    self.label.numberOfLines = 0;
    self.label.font = [UIFont fontWithName:FontPingFangRegular size:14.0];
    self.label.textColor = kWhiteColor;
    self.bezelView.backgroundColor = kBlackColor;
    if (@available(iOS 9.0, *)) {
        [[UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]] setColor:kWhiteColor];
    } else {
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = kWhiteColor;
    }
}

// 设置自定义图文模式
- (void)setHUDModeToCustomImage:(NSString *)image text:(NSString *)text
{
    self.mode = MBProgressHUDModeCustomView;
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    self.label.text = text;
    self.label.numberOfLines = 0;
    self.label.font = [UIFont fontWithName:FontPingFangRegular size:14.0];
    self.label.textColor = kWhiteColor;
    self.bezelView.backgroundColor = kBlackColor;
}

#pragma mark - Normal Show

// 弹出文本提示视图(自动隐藏).
- (void)setHUDModeToTextWithLabelText:(NSString *)labelText
{
    [self setHUDModeToText:labelText];
    [self hide];
}

// 弹出文本提示视图(不自动隐藏).
- (void)setHUDModeToNoHideTextWithLabelText:(NSString *)labelText
{
    [self setHUDModeToText:labelText];
}

// 弹出自定义图文提示视图(自动隐藏).
- (void)setHUDModeToCustomImage:(NSString *)image labelText:(NSString *)labelText
{
    [self setHUDModeToCustomImage:image text:labelText];
    [self hide];
}

// 弹出自定义图文提示视图(不自动隐藏).
- (void)setHUDModeToNoHideCustomImage:(NSString *)image labelText:(NSString *)labelText
{
    [self setHUDModeToCustomImage:image text:labelText];
}

// 弹出菊花图文提示视图(自动隐藏).
- (void)setHUDModeToIndeterminateWithLabelText:(NSString *)labelText
{
    [self setHUDModeToIndeterminateWithText:labelText];
    [self hide];
}

// 弹出菊花图文提示视图(不自动隐藏).
- (void)setHUDModeToNoHideIndeterminateWithLabelText:(NSString *)labelText
{
    [self setHUDModeToIndeterminateWithText:labelText];
}

#pragma mark - Hide

// 隐藏文本提示视图.
- (void)hide
{
    self.animationType = MBProgressHUDAnimationZoomIn;
    [self hideAnimated:true afterDelay:1.2f];
}

// 立刻隐藏文本提示视图.
- (void)hideRightNow
{
    self.animationType = MBProgressHUDAnimationZoomIn;
    [self hideAnimated:YES afterDelay:0.1f];
}

#pragma mark - Error Tip

// 操作错误提示(自动隐藏)
+ (void)showErrorMBProgressHUDAddTo:(UIView *)view WithText:(NSString *)text {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:true];
    [HUD setHUDModeToTextWithLabelText:text];
}

// 操作错误提示(不自动隐藏)
- (void)showErrorNoHideMBProgressHUDAddTo:(UIView *)view WithText:(NSString *)text {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:true];
    [HUD setHUDModeToNoHideTextWithLabelText:text];
}

// 弹出网络错误文本提示视图.(自动隐藏)
- (void)showNetErrorHUDWithCode:(NSInteger)code {
    
    NSString *text;
    if (code == 400) {
        text = @"url错误";
    } else if (code == -1001) {
        text = @"请求超时";
    } else if (code == -1004) {
        text = @"未能连接到服务器";
    } else {
        text = @"网络错误";
    }
    
    self.mode = MBProgressHUDModeText;
    self.label.text = text;
    self.label.numberOfLines = 0;
    self.label.font = [UIFont fontWithName:FontPingFangRegular size:14.0];
    self.label.textColor = kWhiteColor;
    self.bezelView.backgroundColor = kBlackColor;
    [self hide];
}

@end
