//
//  SRTCAVRegionXib.h
//  SRTClibDemo
//
//  Created by wanghaipeng on 2019/5/7.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SRTCUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRTCAVRegionXib : UIView


@property (nonatomic, assign) BOOL isHave;

@property (nonatomic, assign) NSInteger remoterAudioStats;
@property (nonatomic, assign) NSInteger remoterVideoStats;
@property (nonatomic, assign) BOOL isMute;

@property (nonatomic, strong) SRTCUser *user;

- (void)reportAudioLevelWith:(NSUInteger)level;

- (void)didVideoEnabled:(BOOL)enabled;

- (void)closeRegion;


@end

NS_ASSUME_NONNULL_END
