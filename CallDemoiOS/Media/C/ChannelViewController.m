//
//  ChannelViewController.m
//  CallDemoiOS
//
//  Created by feinno on 2020/2/20.
//  Copyright © 2020 feinno. All rights reserved.
//

#import "ChannelViewController.h"
#import "ChatRoomViewController.h"

@interface ChannelViewController () <UITextFieldDelegate>

@end

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    
    
}


- (void)goRoom {
    NSString * text = [self contentWithTag:1];
    if (!text.length) {
        [MBProgressHUD showHUDWith:@"请输入房间号" view:self.view];
        return;
    }
    
    ChannelParams * params = [[ChannelParams alloc] init];
    params.channelName = [text longLongValue];
    params.uid = [MyUser sharedInstance].uccId;
    params.profile = SRTC_ChannelProfile_Vedio;
    params.role = SRTC_ClientRole_Broadcaster;
    
    ChatRoomViewController *vc = [UIStoryboard getViewControllerWithID:@"ChatRoomVC"];
    vc.params = params;
    [self presentViewController:vc animated:true completion:nil];
    
}

- (void)setContent:(NSString *)content tag:(NSInteger)tag {
    UITextField * textField = [self.view viewWithTag:tag];
    textField.text = content;
}

- (NSString *)contentWithTag:(NSInteger)tag {
    UITextField * textField = [self.view viewWithTag:tag];
    return textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)setupViews {
    [self createTitleWithName:@"音视频"];
    //@WeakObj(self)
    
    CGFloat space = 30;//logo与输入框的距离
    UIImageView * logoImageView = [[UIImageView alloc] init];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logoImageView];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(space + WholeNavigationBarHeight);
        make.centerX.mas_equalTo(0);
        
    }];
    
    
    CGFloat margin = 10;//左右间距
    CGFloat titleW = 80;//标题宽度
    CGFloat titleH = 40;//高度
    NSArray * titles = @[@"房间ID"];
    UIView * topView = logoImageView;
    for (int i = 0; i < titles.count; i++) {
        UILabel * label = [[UILabel alloc] init];
        label.font = FONT(15);
        label.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:label];
        label.text = titles[i];
        
        UITextField * textField = nil;
        textField = [[UITextField alloc] init];
        textField.returnKeyType = UIReturnKeyDone;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.font = FONT(15);
        [self.view addSubview:textField];
        textField.tag = i + 1;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.delegate = self;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).offset(i == 0 ? space : margin);
            make.left.mas_equalTo(margin);
            make.width.mas_equalTo(titleW);
            make.height.equalTo(textField.mas_height);
        }];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_top).offset(0);
            make.left.equalTo(label.mas_right).offset(margin);
            make.right.mas_equalTo(-margin);
            make.height.mas_equalTo(titleH);
        }];
        
        topView = textField;
    }
    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.titleLabel.font = FONT(18);
    [loginBtn setBackgroundImage:[UIImage imageWithColor:Main_Color] forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 20;
    [self.view addSubview:loginBtn];
    [loginBtn setTitle:@"进入房间" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(goRoom) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2*margin);
        make.right.mas_equalTo(-2*margin);
        make.bottom.mas_equalTo(-(BottomSafeHeight + 100));
        make.height.mas_equalTo(40);
    }];
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
