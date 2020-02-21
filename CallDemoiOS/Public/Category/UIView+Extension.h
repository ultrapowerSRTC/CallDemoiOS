//
//  UIView+Extension.h
//  SRTClibDemo
//
//  Created by feinno on 2019/12/18.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)

/** 添加圆角 */
- (void)addCorners:(UIRectCorner)corners cornerRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
