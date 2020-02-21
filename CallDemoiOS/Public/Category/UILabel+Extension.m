//
//  UILabel+Extension.m
//  SRTClibDemo
//
//  Created by wanghaipeng on 2019/7/26.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)


- (void)setCornerRadius:(CGFloat)radius {
    self.layer.masksToBounds = true;
    self.clipsToBounds = true;
    self.layer.cornerRadius = 4;
}


@end
