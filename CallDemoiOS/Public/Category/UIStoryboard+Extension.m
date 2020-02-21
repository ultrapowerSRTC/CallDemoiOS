//
//  UIStoryboard+Extension.m
//  SRTClibDemo
//
//  Created by wanghaipeng on 2019/9/3.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import "UIStoryboard+Extension.h"

@implementation UIStoryboard (Extension)


+ (id)getViewControllerWithID:(NSString *)Identifier {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:Identifier];
}



@end
