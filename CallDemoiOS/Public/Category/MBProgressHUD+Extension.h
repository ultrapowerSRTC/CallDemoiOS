//
//  MBProgressHUD+Extension.h
//  Caocao
//
//  Created by wanghaipeng on 2018/3/15.
//  Copyright © 2018年 wanghaipeng. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Extension)

/********************HUD模式**********************/

/// 设置菊花模式
- (void)setHUDModeToIndeterminate;

/// 设置文本模式
- (void)setHUDModeToText:(NSString *)text;

/// 设置自定义图文模式
- (void)setHUDModeToCustomImage:(NSString *)image text:(NSString *)text;

/// 设置菊花图文模式
- (void)setHUDModeToIndeterminateWithText:(NSString *)text;

/**********************隐藏***********************/

/// 隐藏文本提示视图.
- (void)hide;

/// 立刻隐藏文本提示视图.
- (void)hideRightNow;

/*******************错误提示***********************/

/// 弹出网络错误文本提示视图.
- (void)showNetErrorHUDWithCode:(NSInteger)code;

/// 操作错误提示
+ (void)showErrorMBProgressHUDAddTo:(UIView *)view WithText:(NSString *)text;

/*******************正常弹窗**********************/

/// 弹出文本提示视图(自动隐藏).
- (void)setHUDModeToTextWithLabelText:(NSString *)labelText;

/// 弹出文本提示视图(不自动隐藏).
- (void)setHUDModeToNoHideTextWithLabelText:(NSString *)labelText;

/// 弹出自定义图文提示视图(自动隐藏).
- (void)setHUDModeToCustomImage:(NSString *)image labelText:(NSString *)labelText;

/// 弹出自定义图文提示视图(不自动隐藏).
- (void)setHUDModeToNoHideCustomImage:(NSString *)image labelText:(NSString *)labelText;

/// 弹出菊花图文提示视图(自动隐藏).
- (void)setHUDModeToIndeterminateWithLabelText:(NSString *)labelText;

/// 弹出菊花图文提示视图(不自动隐藏).
- (void)setHUDModeToNoHideIndeterminateWithLabelText:(NSString *)labelText;


// 文本hud
+ (void)showHUDWith:(NSString *)text view:(UIView *)view;


@end
