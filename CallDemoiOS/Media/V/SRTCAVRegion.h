//
//  SRTCAVRegion.h
//  SRTClibDemo
//
//  Created by wanghaipeng on 2019/5/6.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SRTCUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRTCAVRegion : UIView


@property (weak, nonatomic) IBOutlet UIImageView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *audioLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;


@end

NS_ASSUME_NONNULL_END
