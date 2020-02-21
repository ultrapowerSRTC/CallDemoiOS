//
//  UIView+Extension.m
//  SRTClibDemo
//
//  Created by feinno on 2019/12/18.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)addCorners:(UIRectCorner)corners cornerRadius:(CGFloat)radius {
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
