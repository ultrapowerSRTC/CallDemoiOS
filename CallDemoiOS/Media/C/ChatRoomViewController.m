//
//  ChatRoomViewController.m
//  SRTClibDemo
//
//  Created by wanghaipeng on 2019/5/6.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "SRTCAVRegionXib.h"

@interface ChatRoomViewController () <FeinnoMegLibDelegate>


@property (copy, nonatomic) NSMutableArray *avRegions;

@property (strong, nonatomic) FeinnoMegLib *manager;

@property (strong, nonatomic) SRTCVideoCompositingLayout *videoLayout;

@property (weak, nonatomic) IBOutlet UIImageView *meImgView;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UILabel *roomIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@property (weak, nonatomic) IBOutlet UILabel *audioStatsLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoStatsLabel;
@property (weak, nonatomic) IBOutlet UIView *avRegionsView;

@property (nonatomic, assign) BOOL isVedioRetention;
@property (nonatomic, assign) BOOL isSpeaker;
@property (nonatomic, assign) BOOL isMute;


@end

@implementation ChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canSideBack = NO;
    self.isMute = false;
    self.isSpeaker = true;
    self.isVedioRetention = false;
    
    self.roomIDLabel.text = [@"房号:" append:[NSString longToString:self.params.channelName]];
    self.idLabel.text = [NSString longToString:self.params.uid];
    
    if (self.params.role == SRTC_ClientRole_Anchor) {
        self.videoLayout = [[SRTCVideoCompositingLayout alloc] init];
        //竖屏模式
        self.videoLayout.canvasWidth = kScreenWidth;
        self.videoLayout.canvasHeight = kScreenHeight;
    }
    
    [self.avRegionsView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[SRTCAVRegionXib class]]) {
            SRTCAVRegionXib *region = obj;
            [self.avRegions addObject:region];
        }
    }];
    
    // 加入频道
    [self joinCannel];
}

- (void)joinCannel
{
    // 初始化 FeinnoMegLib
    FeinnoMegLib *manager = [FeinnoMegLib sharedInstance];
    self.manager = manager;
    [manager initMediaEngineWithDelegate:self];
    [manager muteLocalAudioStream:false];
    [manager enableAudioVolumeIndication:200 smooth:3];//音量监听
 
    if (self.params.profile == SRTC_ChannelProfile_Vedio) {
        [manager enableVideo];
    }
    
    BOOL swapWH = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    SRTCVideoProfile profile = SRTC_VideoProfile_Default;
    [manager setVideoProfile:profile swapWidthAndHeight:swapWH];
    
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [hud setHUDModeToIndeterminate];
    @WeakObj(self)
    // 正式加入房间
    [manager joinChannelWithParamas:self.params success:^(id  _Nonnull response) {
        [hud hideRightNow];
        [selfWeak setManager];
    } faild:^(NSInteger rspCode, NSError * _Nullable error, NSString * _Nullable step) {
        if (rspCode == kCFURLErrorNotConnectedToInternet) {
            [hud setHUDModeToTextWithLabelText:@"请连接网络"];
            return ;
        }
        [hud hideRightNow];
        NSString *message = [NSString stringWithFormat:@"%@ 出错\n 错误码: %ld\n 错误信息: %@", step, (long)rspCode, error.domain];
        [UIAlertController showConfirmAlertWithMessage:message vc:self handler:^{
            [selfWeak dismissViewControllerAnimated:NO completion:nil];
        }];
        
    }];
}

- (void)setManager
{
    SRTCVideoCanvas *videoCanvas = [[SRTCVideoCanvas alloc] init];
    videoCanvas.uid = self.params.uid;
    videoCanvas.renderMode = SRTC_Render_Adaptive;
    videoCanvas.view = self.meImgView;
    [self.manager setupLocalVideo:videoCanvas];
}

- (IBAction)leftBtnsAction:(UIButton *)sender {
    [self.manager switchCamera];
}

- (IBAction)exitChannel:(id)sender {
    [UIAlertController showAlertStyleWithTitle:@"提示" message:@"你确定要退出房间吗？" leftText:@"取消" rightText:@"确定" vc:self leftHandler:nil rightHandler:^{
        [self exitChannel];
    }];
}

- (void)exitChannel {
    [_manager leaveChannelWithsuccess:^(id  _Nonnull response) {
        
    } faild:^(NSInteger rspCode, NSError * _Nullable error, NSString * _Nullable step) {
        
    }];
    [_manager destroy];
    _manager = nil;
    [self dismissViewControllerAnimated:true completion:nil];
}


#pragma mark -
#pragma mark - SRTCLibManagerDelegate
/**
 发生错误回调
 通常情况下，SDK上报的错误意味着SDK无法自动恢复，需要应用程序干预或提示用户。
 
 @param errorCode 错误码
 */
- (void)FeinnoMegLib:(FeinnoMegLib *)manager didOccurError:(SRTCChannelErrorCode)errorCode
{
    NSString *errorText;
    switch (errorCode) {
        case SRTC_ChannelError_InvalidChannelName:
            errorText = @"无效的房间名称";
            break;
        case SRTC_ChannelError_Enter_TimeOut:
            errorText = @"超时,10秒未收到服务器返回结果";
            break;
        case SRTC_ChannelError_Enter_VerifyFailed:
            errorText = @"验证码错误";
            break;
        case SRTC_ChannelError_Enter_Unknown:
            errorText = @"进入房间错误";
            break;
        case SRTC_ChannelError_NoAudioData:
//            errorText = @"长时间没有上行音频数据";
            errorText = @"";
            break;
        case SRTC_ChannelError_NoVideoData:
//            errorText = @"长时间没有上行视频数据";
            errorText = @"";
            break;
        case SRTC_ChannelError_NoReceivedAudioData:
//            errorText = @"长时间没有下行音频数据";
            errorText = @"";
            break;
        case SRTC_ChannelError_NoReceivedVideoData:
//            errorText = @"长时间没有下行视频数据";
            errorText = @"";
            break;
        case SRTC_ChannelError_InvalidChannelKey:
            errorText = @"无效的channelKey";
            break;
        case SRTC_ChannelError_Enter_Failed:
            errorText = @"无法连接服务器";
            break;
        default:
            errorText = @"未知错误";
            break;
    }
    
    if (!errorText.length) {
        return;
    }
    
    [UIAlertController showConfirmAlertWithMessage:errorText vc:self handler:^{
        [self exitChannel];
    }];
}

/**
 其他用户进入房间
 
 @param uid 用户id
 @param clientRole 用户角色
 @param isVideoEnabled 是否启用本地视频
 @param elapsed 加入频道开始到该回调触发的延迟（毫秒)
 */
- (void)FeinnoMegLib:(FeinnoMegLib *)manager didJoinedOfUid:(int64_t)uid clientRole:(SRTCClientRole)clientRole
        isVideoEnabled:(BOOL)isVideoEnabled elapsed:(NSInteger)elapsed
{
    [self.avRegions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SRTCAVRegionXib *region = obj;
        if (!region.isHave) {
            
            SRTCUser *user = [[SRTCUser alloc] init];
            user.uid = uid;
            user.isMute = false;
            user.role = clientRole;
            
            region.user = user;
            
            // 提交参与者的位置
            if (clientRole == SRTC_ClientRole_Broadcaster) {
                // 自定义位置
                [self refreshVideoCompositingLayout];
                // 默认位置
//                [self.manager setVideoCompositingLayoutDefaultWithUid:uid];
            }
            
            *stop = true;
        }
    }];
}

- (void)refreshVideoCompositingLayout {
    
    if (!self.videoLayout) {
        return;
    }
    
    NSMutableArray *regions = [NSMutableArray new];
    
    SRTCVideoCompositingRegion *anchor = [SRTCVideoCompositingRegion new];
    anchor.uid = self.params.uid;
    anchor.x = 0;
    anchor.y = 0;
    anchor.width = 1;
    anchor.height = 0.5;
    anchor.zOrder = 0;
    anchor.alpha = 1;
    anchor.renderMode = SRTC_Render_Adaptive;
    [regions addObject:anchor];
    
    [self.avRegions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SRTCAVRegionXib *region = obj;
        if (region.user.role == SRTC_ClientRole_Broadcaster ) {
            
            SRTCVideoCompositingRegion *bc = [SRTCVideoCompositingRegion new];
            bc.uid = region.user.uid;
            bc.x = 0;
            bc.y = 0.5;
            bc.width = 1;
            bc.height = 0.5;
            bc.zOrder = 1;
            bc.alpha = 1;
            bc.renderMode = SRTC_Render_Adaptive;
            [regions addObject:bc];
            
//            double x = region.frame.origin.x;
//            double y = region.frame.origin.y;
//            double width = region.frame.size.width;
//            double height = region.frame.size.height;
//
//            SRTCVideoCompositingRegion *bc = [SRTCVideoCompositingRegion new];
//            bc.uid = region.user.uid;
//            bc.x = x / kScreenWidth;
//            bc.y = y / kScreenHeight;
//            bc.width = width / kScreenWidth;
//            bc.height = height / kScreenHeight;
//            bc.zOrder = 1;
//            bc.alpha = 1;
//            bc.renderMode = SRTC_Render_Adaptive;
//            [regions addObject:bc];
        }
    }];
    
    self.videoLayout.regions = regions;
    NSLog(@"regions = %@", self.videoLayout.regions);
    
    [self.manager setVideoCompositingLayout:self.videoLayout];
}

/**
 其他用户离线回调
 
 @param uid 用户ID
 @param reason 离线原因
 */
- (void)FeinnoMegLib:(FeinnoMegLib *)manager didOfflineOfUid:(int64_t)uid reason:(SRTCUserOfflineReason)reason
{
    [self.avRegions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SRTCAVRegionXib *region = obj;
        if (region.user.uid == uid) {
            
            SRTCAVRegionXib *region = self.avRegions[idx];
            [region closeRegion];
            
            *stop = true;
        }
    }];
}

/**
 用户被踢出房间回调
 
 @param uid 用户id
 @param reason 被踢原因
 */
- (void)FeinnoMegLib:(FeinnoMegLib *)manager didKickedOutOfUid:(int64_t)uid reason:(SRTCKickedOutReason)reason
{
    NSString *errorText;
    switch (reason) {
        case SRTC_KickedOut_KickedByHost:
            errorText = @"被主播踢出";
            break;
        case SRTC_KickedOut_PushRtmpFailed:
            errorText = @"rtmp推流失败";
            break;
        case SRTC_KickedOut_ServerOverload:
            errorText = @"服务器过载";
            break;
        case SRTC_KickedOut_MasterExit:
            errorText = @"主播已退出";
            break;
        case SRTC_KickedOut_ReLogin:
            errorText = @"重复登录";
            break;
        case SRTC_KickedOut_NoVideoData:
//            errorText = @"长时间没有上行视频数据";
            errorText = @"";
            break;
        case SRTC_KickedOut_NoAudioData:
//            errorText = @"长时间没有上行音频数据";
            errorText = @"";
            break;
        case SRTC_KickedOut_NewChairEnter:
            errorText = @"其他人以主播身份进入";
            break;
        default:
            errorText = @"未知错误";
            break;
    }
    
    if (!errorText.length) {
        return;
    }
    
    [UIAlertController showConfirmAlertWithMessage:errorText vc:self handler:^{
        [self exitChannel];
    }];
}

/**
 *  远端用户音量回调
 *  提示谁在说话及其音量，默认禁用。可通过enableAudioVolumeIndication方法设置。
 *
 *  @param uid                 用户ID
 *  @param audioLevel          非线性区间[0,9]
 *  @param audioLevelFullRange 线性区间[0,32768]
 */
- (void)FeinnoMegLib:(FeinnoMegLib *)manager reportAudioLevel:(int64_t)uid
            audioLevel:(NSUInteger)audioLevel audioLevelFullRange:(NSUInteger)audioLevelFullRange
{
    if (self.params.uid == uid) {
        [self.voiceBtn setImage:[self getVoiceImage:audioLevel] forState:UIControlStateNormal];
    } else {
        [self.avRegions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SRTCAVRegionXib *region = obj;
            if (region.user.uid == uid) {
                [region reportAudioLevelWith:audioLevel];
                *stop = true;
            }
        }];
    }
}

- (UIImage *)getVoiceImage:(NSInteger)audioLevel {
    
    if (self.isMute) {
         return [UIImage imageNamed:@"voice_close"];
    }
    
    NSString *name = @"voice_small";
    if (audioLevel < 1) {
        return nil;//声音太小，相当于没有说话
    } else if (audioLevel < 4) {
        name = self.isSpeaker ? @"voice_small" : @"tingtong_small";
    } else if (audioLevel < 7) {
        name = self.isSpeaker ? @"voice_middle" : @"tingtong_middle";
    } else {
        name = self.isSpeaker ? @"voice_big" : @"tingtong_big";
    }
    return [UIImage imageNamed:name];
}

/**
 *  用户音频静音回调
 *
 *  @param muted YES: 静音，NO: 取消静音。
 *  @param uid   用户ID
 */
- (void)FeinnoMegLib:(FeinnoMegLib *)manager didAudioMuted:(BOOL)muted byUid:(int64_t)uid
{
    [self.avRegions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SRTCAVRegionXib *region = obj;
        if (region.user.uid == uid) {
            region.isMute = muted;
            *stop = true;
        }
    }];
}

/**
 用户启用/关闭视频回调
 
 @param enabled 是否开启视频: true 开启; false 关闭;
 @param uid 用户ID
 */
- (void)FeinnoMegLib:(FeinnoMegLib *)manager didVideoEnabled:(BOOL)enabled byUid:(int64_t)uid
{
    [self.avRegions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SRTCAVRegionXib *region = obj;
        if (region.user.uid == uid) {
            [region didVideoEnabled:enabled];
            *stop = true;
        }
    }];
}

/**
 *  本地音频统计回调
 *
 *  @param stats 本地音频的统计信息
 */
- (void)FeinnoMegLib:(FeinnoMegLib *)manager localAudioStats:(SRTCLocalAudioStats *)stats
{
    self.audioStatsLabel.text = [NSString stringWithFormat:@"A-↑%lukbps", (unsigned long)stats.sentBitrate];
}

/**
 *  远端音频统计回调
 *
 *  @param stats 远端音频的统计信息
 */
- (void)FeinnoMegLib:(FeinnoMegLib *)manager remoteAudioStats:(SRTCRemoteAudioStats *)stats
{
    [self.avRegions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SRTCAVRegionXib *region = obj;
        if (region.user.uid == stats.uid) {
            region.remoterAudioStats = stats.receivedBitrate;
            *stop = true;
        }
    }];
}

/**
 *  本地视频统计回调
 *
 *  @param stats 本地视频的统计信息
 */
- (void)FeinnoMegLib:(FeinnoMegLib *)manager localVideoStats:(SRTCLocalVideoStats *)stats
{
    self.videoStatsLabel.text = [NSString stringWithFormat:@"V-↑%lukbps", (unsigned long)stats.sentBitrate];
}

/**
 *  远端视频统计回调
 *
 *  @param stats 远端视频的统计信息
 */
- (void)FeinnoMegLib:(FeinnoMegLib *)manager remoteVideoStats:(SRTCRemoteVideoStats *)stats
{
    [self.avRegions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SRTCAVRegionXib *region = obj;
        if (region.user.uid == stats.uid) {
            region.remoterVideoStats = stats.receivedBitrate;
            *stop = true;
        }
    }];
}


/**
 *  网络连接丢失回调
 */
- (void)FeinnoMegLibConnectionDidLost:(FeinnoMegLib *)manager
{
    [MBProgressHUD showHUDWith:@"网络丢失" view:self.view];
}

/**
 当出现异常断开后，重连成功。
 */
- (void)FeinnoMegLibReconnectServerSucceed:(FeinnoMegLib *)manager
{
    [MBProgressHUD showHUDWith:@"重连成功" view:self.view];
}

/**
 *  当出现异常断开后，重连超时
 *  若重连时间超时服务器的容忍范围，服务器将会拒绝其进入房间，其房间状态将不可用。此时触发该回调。
 *  上层应该在收到此回调后退出房间。
 */
- (void)FeinnoMegLibReconnectServerTimeout:(FeinnoMegLib *)manager
{
    [MBProgressHUD showHUDWith:@"网络丢失，请检查网络" view:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self exitChannel];
    });
}

/**
 *  离开频道成功回调
 *
 *  @param stats 统计数据
 */
- (void)FeinnoMegLib:(FeinnoMegLib *)manager didLeaveChannelWithStats:(SRTCStats *)stats
{
//    NSLog(@"成功离开房间");
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - 懒加载
- (NSMutableArray *)avRegions
{
    if (!_avRegions) {
        _avRegions = [NSMutableArray new];
    }
    return _avRegions;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
