//
//  ChatRoomViewController.h
//  SRTClibDemo
//
//  Created by wanghaipeng on 2019/5/6.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SRTCLib/SRTCParams.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomViewController : BaseViewController


@property (nonatomic ,strong) ChannelParams *params;
@property (nonatomic ,assign) BOOL isVedioRetains;

@property (nonatomic, assign) NSInteger currentMode;

@end

NS_ASSUME_NONNULL_END
