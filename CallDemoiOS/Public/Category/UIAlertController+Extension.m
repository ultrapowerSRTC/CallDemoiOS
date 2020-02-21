//
//  UIAlertController+Extension.m
//  Caocao
//
//  Created by wanghaipeng on 2018/4/16.
//  Copyright © 2018年 wanghaipeng. All rights reserved.
//

#import "UIAlertController+Extension.h"

@implementation UIAlertController (Extension)

/// 显示文案弹窗
+ (void)showConfirmAlertWithMessage:(NSString *)message vc:(UIViewController *)vc
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:yes];
    
    [vc presentViewController:alert animated:true completion:nil];
}

/// 显示文案弹窗，并返回处理方法
+ (void)showConfirmAlertWithMessage:(NSString *)message vc:(UIViewController *)vc handler:(void (^)(void))handler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }];
    [alert addAction:yes];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

/// 显示文案弹窗，并返回左右按钮的处理方法
+ (void)showAlertStyleWithTitle:(NSString *)title message:(NSString *)message leftText:(NSString *)leftText rightText:(NSString *)rightText vc:(UIViewController *)vc leftHandler:(void (^)(void))leftHandler rightHandler:(void (^)(void))rightHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (!leftText.length) {
        leftText = @"取消";
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:leftText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (leftHandler) {
            leftHandler();
        }
    }];
    [alert addAction:cancel];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:rightText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (rightHandler) {
            rightHandler();
        }
    }];
    [alert addAction:yes];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

/// 显示输入框的alert
+ (void)showTextFieldAlertWithMessage:(NSString *)message text:(NSString *)text vc:(UIViewController *)vc handler:(void (^)(NSString *text))handler
{
    __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *field = alert.textFields[0];
        if (handler) {
            handler(field.text);
        }
    }];
    [alert addAction:yes];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.tintColor = UIColor.blackColor;
        textField.text = text;
     }];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

/// 详情1界面的sheet
+ (void)detail_1MoreActionSheetWithVc:(UIViewController *)vc type:(int)type handler1:(void (^)(int actionType))handler1 handler2:(void (^)(void))handler2
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *title1 = @"从我的小程序里移除";
    if (type == 2) {
        title1 = @"添加到我的小程序";
    }
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:title1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler1) {
            handler1(type);
        }
    }];
    [alert addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"关于小程序名称" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler2) {
            handler2();
        }
    }];
    [alert addAction:action2];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [vc presentViewController:alert animated:true completion:nil];
}

/// 详情2界面的sheet
+ (void)detail_2MoreActionSheetWithVc:(UIViewController *)vc type:(int)type handler1:(void (^)(int actionType))handler1
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *title1 = @"从我的小程序里移除";
    if (type == 2) {
        title1 = @"添加到我的小程序";
    }
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:title1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler1) {
            handler1(type);
        }
    }];
    [alert addAction:action1];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [vc presentViewController:alert animated:true completion:nil];
}

+ (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message menus:(NSArray<NSString *> *)menus vc:(UIViewController *)vc handle:(void (^)(NSInteger index))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
   
    for (int i = 0; i < menus.count; i++) {
        NSString * menu = menus[i];
        UIAlertAction * action = [UIAlertAction actionWithTitle:menu style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                NSInteger index = [menus indexOfObject:action.title];
                handler(index);
            }
        }];
        [alert addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [vc presentViewController:alert animated:true completion:nil];
}

@end
