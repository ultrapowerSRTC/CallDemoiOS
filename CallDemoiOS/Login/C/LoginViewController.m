//
//  LoginViewController.m
//  CallDemoiOS
//
//  Created by feinno on 2020/2/20.
//  Copyright © 2020 feinno. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

/** 登录类型 2:注册用户 1:游客 */
@property (nonatomic, assign) NSInteger loginType;
/** 登录类型名称 */
@property (nonatomic, strong) NSArray * loginTypeNames;
@property (nonatomic, strong) UILabel * uccidLabel;
@property (nonatomic, strong) UITextField * uccidField;

/** uccid */
@property (nonatomic, copy) NSString * uccid;
/** token */
@property (nonatomic, copy) NSString * token;
/** nickName */
@property (nonatomic, copy) NSString * nickName;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
    
    if ([MyUser sharedInstance].uccId != 0) {
        [self setContent:[NSString longToString:[MyUser sharedInstance].uccId] tag:1];
        [self login];
    }
}


- (void)login {
    [self.view endEditing:YES];
   
    if (![MyUser sharedInstance].address.length || ![MyUser sharedInstance].appKey.length || ![MyUser sharedInstance].appSecret.length) {
        [MBProgressHUD showHUDWith:@"请完善AppKey等信息" view:self.view];
        return;
    }
    
    //游客
    _uccid = [self contentWithTag:1];
    _token = @"";
    
    if (!_uccid.length) {
        [MBProgressHUD showHUDWith:@"请输入uccid" view:self.view];
        return;
    }
    NSString * firstStr = [_uccid substringToIndex:1];
    if ([firstStr intValue] == 0) {
        [MBProgressHUD showHUDWith:@"请输入有效的uccid" view:self.view];
        return;
    }
    if (_uccid.length > 15) {
        [MBProgressHUD showHUDWith:@"有效的uccid长度为1~15位" view:self.view];
        return;
    }
    
    SSOParams *params = [[SSOParams alloc] init];
    params.address = [MyUser sharedInstance].address;
    params.appkey = [MyUser sharedInstance].appKey;
    params.uccId = [_uccid longLongValue];
    params.token = _token;
    params.nickName = _nickName;
    params.curtime = [self getCurrentTimeInterval];
    params.checkSum = [[[[MyUser sharedInstance].appSecret append:_uccid] append:params.curtime] sha256];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:true];
    [hud setHUDModeToIndeterminate];
    
    @WeakObj(self)
    // 初始化 FeinnoMegLib, 游客登录
    [[FeinnoMegLib sharedInstance] touristWithParams:params success:^(id  _Nonnull response) {
        
        [selfWeak loginSuccessWithHud:hud];
        
    } faild:^(NSInteger rspCode, NSError * _Nullable error, NSString * _Nullable step) {
        
        [selfWeak loginFaildWithHud:hud rspCode:rspCode error:error step:step];
    }];
    
}

- (void)loginSuccessWithHud:(MBProgressHUD *)hud
{
    [hud hideRightNow];

    // 更新登录信息
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"type"] = @(_loginType);
    dic[@"uccId"] = _uccid;
    dic[@"token"] = _token;
    dic[@"nickName"] = _nickName;
    
    [[MyUser sharedInstance] updateUserData:dic];
    
    [SRTCApp goMain];
//    // 通知其他界面刷新
//    [[NSNotificationCenter defaultCenter] postNotificationName:kSRTCRefreshLoginData object:nil];
    
    [MBProgressHUD showHUDWith:@"保存并登录成功" view:[UIApplication sharedApplication].keyWindow];
}

- (void)loginFaildWithHud:(MBProgressHUD *)hud rspCode:(NSInteger)rspCode error:(NSError * _Nullable)error step:(NSString * _Nullable)step
{
    if (rspCode == kCFURLErrorNotConnectedToInternet) {
        [hud setHUDModeToTextWithLabelText:@"请连接网络"];
        return ;
    }
    
    [hud hideRightNow];
    
    NSLog(@"rspCode = %ld\n error = %@\n step = %@", (long)rspCode, error, step);
    NSString *message = [NSString stringWithFormat:@"%@ 出错\n 错误码: %ld\n 错误信息: %@", step, (long)rspCode, error.localizedDescription];
    [UIAlertController showConfirmAlertWithMessage:message vc:self];
}

/// 获取当前时间戳
- (NSString *)getCurrentTimeInterval {
    //获取当前时间0秒后的时间
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    // *1000 是精确到毫秒，不乘就是精确到秒
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
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
    [self createBack];
    [self createTitleWithName:@"登录设置"];
    
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
    NSArray * titles = @[@"用户ID"];
    UIView * topView = logoImageView;
    for (int i = 0; i < titles.count; i++) {
        UILabel * label = [[UILabel alloc] init];
        label.font = FONT(15);
        label.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:label];
        label.text = titles[i];
        
        UITextField * textField = nil;
        textField = [[UITextField alloc] init];
        if (i == 0) {
            _uccidField = textField;
            _uccidLabel = label;
        }
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
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
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
