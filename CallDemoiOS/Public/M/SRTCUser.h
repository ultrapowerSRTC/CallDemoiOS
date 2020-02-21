//
//  SRTCUser.h
//  SRTClibDemo
//
//  Created by wanghaipeng on 2019/5/7.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SRTCLib/FeinnoMegLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRTCUser : NSObject

@property (nonatomic, assign) int64_t uid;
@property (nonatomic, assign) BOOL isMute;//是否静音  default is NO
@property (nonatomic, assign) SRTCClientRole role;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) BOOL status;//禁言状态 YES:被禁言 NO:未被禁言

@end

NS_ASSUME_NONNULL_END
