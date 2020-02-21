//
//  BaseButton.m
//  SRTClibDemo
//
//  Created by wanghaipeng on 2019/7/1.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import "BaseButton.h"

@implementation BaseButton


- (void)drawRect:(CGRect)rect {
    self.layer.masksToBounds = true;
    self.clipsToBounds = true;
    self.layer.cornerRadius = 4;
}


@end
