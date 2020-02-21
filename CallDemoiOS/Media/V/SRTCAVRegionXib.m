//
//  SRTCAVRegionXib.m
//  SRTClibDemo
//
//  Created by wanghaipeng on 2019/5/7.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import "SRTCAVRegionXib.h"

#import "SRTCAVRegion.h"

@interface SRTCAVRegionXib ()

@property (weak, nonatomic) SRTCAVRegion *region;
@property (strong, nonatomic) SRTCVideoCanvas *videoCanvas;

@end

@implementation SRTCAVRegionXib

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.isHave = false;
        
        [self addRegionView];
    }
    return self;
}

- (void)addRegionView {
    self.region.frame = self.bounds;
    self.region.alpha = 0.7;
    self.region.backgroundColor = UIColor.clearColor;
    [self addSubview:self.region];
}


- (void)setUser:(SRTCUser *)user {
    
    _user = user;
    
    self.isHave = true;
    self.region.alpha = 1.0;
    
    [self.region.voiceBtn setImage:[UIImage imageNamed:@"voice_small"] forState:UIControlStateNormal];
    self.region.idLabel.hidden = false;
    self.region.voiceBtn.hidden = false;
    self.region.audioLabel.hidden = false;
    self.region.videoLabel.hidden = false;
    self.region.idLabel.text = [NSString stringWithFormat:@"%lld", user.uid];
    
    self.videoCanvas = [[SRTCVideoCanvas alloc] init];
    self.videoCanvas.uid = user.uid;
    self.videoCanvas.renderMode = SRTC_Render_Adaptive;
    self.videoCanvas.view = self.region.videoView;
    [[FeinnoMegLib sharedInstance] setupRemoteVideo:self.videoCanvas];
    
    [self setIsMute:user.isMute];
}

- (void)setRemoterAudioStats:(NSInteger)remoterAudioStats {
    
    _remoterAudioStats = remoterAudioStats;
    
    self.region.audioLabel.text = [NSString stringWithFormat:@"A-↓ %ldkbps", (long)remoterAudioStats];
}

- (void)setRemoterVideoStats:(NSInteger)remoterVideoStats {
    
    _remoterVideoStats = remoterVideoStats;
    
    self.region.videoLabel.text = [NSString stringWithFormat:@"V-↓ %ldkbps", (long)remoterVideoStats];
}

- (void)setIsMute:(BOOL)isMute {
    
    _isMute = isMute;
    
    NSString *name = isMute ? @"speaking_closed" : @"voice_small";
    [self.region.voiceBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
}

- (void)reportAudioLevelWith:(NSUInteger)level {
    [self.region.voiceBtn setImage:[self getVoiceImage:level] forState:UIControlStateNormal];
}

- (UIImage *)getVoiceImage:(NSInteger)audioLevel {
    
    NSString *name = @"voice_close";
    
    if (self.isMute) {
        return [UIImage imageNamed:name];
    }
    
    if (audioLevel < 1) {
        return nil;//声音太小，相当于没有说话
    } else if (audioLevel < 4) {
        name = @"voice_small";
    } else if (audioLevel < 7) {
        name = @"voice_middle";
    } else {
        name = @"voice_big";
    }
    
    return [UIImage imageNamed:name];
}

- (void)didVideoEnabled:(BOOL)enabled {
    if (enabled) {
        self.videoCanvas.view = self.region.videoView;
    } else {
        self.region.videoView.image = [UIImage imageNamed:@"video_head"];
    }
}

- (void)closeRegion {
    
    self.isHave = false;
    self.videoCanvas = nil;
    
    self.region.alpha = 0.7;
    self.region.idLabel.hidden = true;
    self.region.voiceBtn.hidden = true;
    self.region.audioLabel.hidden = true;
    self.region.videoLabel.hidden = true;
    
    self.region.videoView.image = [UIImage imageNamed:@"video_head"];
}

- (SRTCAVRegion *)region {
    if (!_region) {
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        UINib *nib = [UINib nibWithNibName:@"SRTCAVRegion" bundle:bundle];
        _region = [[nib instantiateWithOwner:self options:nil] firstObject];
    }
    return _region;
}

@end
