//
//  HouseTypeView.h
//  Disaster
//
//  Created by wanghaipeng on 2018/7/3.
//  Copyright © 2018年 wanghaipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTypeView : UIView


@property (nonatomic, copy) void(^buttonsClickBlock)(NSInteger index);

@property (nonatomic, copy) NSArray *titles;


@end

NS_ASSUME_NONNULL_END
