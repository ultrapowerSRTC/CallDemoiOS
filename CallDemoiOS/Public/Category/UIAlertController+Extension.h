//
//  UIAlertController+Extension.h
//  Caocao
//
//  Created by wanghaipeng on 2018/4/16.
//  Copyright © 2018年 wanghaipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Extension)


/**
 显示文案弹窗

 @param message 消息
 @param vc 控制器
 */
+ (void)showConfirmAlertWithMessage:(NSString *)message vc:(UIViewController *)vc;

/**
 显示文案弹窗，并返回处理方法

 @param message 消息
 @param vc 控制器
 @param handler 回调
 */
+ (void)showConfirmAlertWithMessage:(NSString *)message vc:(UIViewController *)vc handler:(void (^)(void))handler;

/**
 显示文案弹窗，并返回左右按钮的处理方法

 @param title 标题
 @param message 消息
 @param leftText 左按钮文案
 @param rightText 右按钮文案
 @param vc 控制器
 @param leftHandler 左按钮回调
 @param rightHandler 右按钮回调
 */
+ (void)showAlertStyleWithTitle:(NSString *)title message:(NSString *)message leftText:(NSString *)leftText rightText:(NSString *)rightText vc:(UIViewController *)vc leftHandler:(void (^)(void))leftHandler rightHandler:(void (^)(void))rightHandler;


/**
 显示输入框的alert

 @param message 信息
 @param text 输入框默认显示文字
 @param vc 控制器
 @param handler 回调
 */
+ (void)showTextFieldAlertWithMessage:(NSString *)message text:(NSString *)text vc:(UIViewController *)vc handler:(void (^)(NSString *text))handler;

/**
 显示带取消的actionsheet
 
 @param title 标题
 @param message 提示
 @param vc 控制器
 @param menus 菜单
 @param handler 回调
 */
+ (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message menus:(NSArray<NSString *> *)menus vc:(UIViewController *)vc handle:(void (^)(NSInteger index))handler;

@end
