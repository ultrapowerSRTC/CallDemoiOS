//
//  BaseViewController.h
//  SRTClibDemo
//
//  Created by feinno on 2019/10/17.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

/** 是否可以边缘返回 Default is YES */
@property (nonatomic, assign)BOOL canSideBack;

- (void)back;
/** 创建并设置navigationItem上的返回按钮 */
- (UIButton *)createBack;
/** 创建并设置navigationItem上的返回按钮及关联点击方法 */
- (UIButton *)createBackWith:(SEL)backClick;
/** 创建并设置navigationItem上的带标题的返回按钮及关联点击方法 */
- (UIButton *)createBackWith:(SEL)backClick title:(NSString *)titel;
/** 创建并设置navigationItem.titleView */
- (UILabel *)createTitleWithName:(NSString *)title;

/** 离开界面:设置竖屏 */
- (void)setDeviceInterfaceOrientationPortrait;
/** 进入界面：设置横屏 */
- (void)setDeviceInterfaceOrientationLeft;
/** 强制屏幕旋转 */
- (void)setDeviceInterfaceOrientation:(UIDeviceOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
