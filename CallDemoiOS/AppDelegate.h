//
//  AppDelegate.h
//  CallDemoiOS
//
//  Created by feinno on 2020/2/20.
//  Copyright © 2020 feinno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/PHPhotoLibrary.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//记录当前界面是否支持横竖屏旋转
@property (assign, nonatomic)BOOL allowAutoRotate;

/** 进入App */
- (void)goMain;
/** 进入登录页面 */
- (void)goLogin;


@end

