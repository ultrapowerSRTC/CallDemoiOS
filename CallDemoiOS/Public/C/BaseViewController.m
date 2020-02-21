//
//  BaseViewController.m
//  SRTClibDemo
//
//  Created by feinno on 2019/10/17.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation BaseViewController
- (instancetype)init {
    if (self = [super init]) {
        [self configDefault];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configDefault];
}

- (void)configDefault {
    // iOS13默认变成了Automatic，最上面会出现空余，不好适配  这里改成FullScreen，方便适配
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    _canSideBack = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.edgesForExtendedLayout = UIRectEdgeNone;//已设置translucent为NO，这个不需要了
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 解决右滑返回失效问题
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.canSideBack;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (UIButton *)createBack {
    return [self createBackWith:@selector(back)];
}

- (void)back {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIButton *)createBackWith:(SEL)backClick {
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 24, 40);
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:backClick forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItems = @[leftItem];
    
    return leftBtn;
}

- (UIButton *)createBackWith:(SEL)backClick title:(NSString *)titel {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button setTitle:titel forState:UIControlStateNormal];
    [button setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:backClick forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    button.frame = CGRectMake(0, 0, 100, 40);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 100-24)];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[leftItem];
    
    return button;
}

- (UILabel *)createTitleWithName:(NSString *)title {
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
    
    return titleLabel;
}


// 离开界面:设置竖屏
- (void)setDeviceInterfaceOrientationPortrait {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowAutoRotate = false;
    [self setDeviceInterfaceOrientation:UIDeviceOrientationLandscapeLeft];//防止手动先把设备置为竖屏,导致下面的语句失效
    [self setDeviceInterfaceOrientation:UIDeviceOrientationPortrait];
}

// 进入界面：设置横屏
- (void)setDeviceInterfaceOrientationLeft {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowAutoRotate = true;
    [self setDeviceInterfaceOrientation:UIDeviceOrientationPortrait];//防止手动先把设备置为横屏,导致下面的语句失效
    [self setDeviceInterfaceOrientation:UIDeviceOrientationLandscapeLeft];
}

//方法2：强制屏幕旋转
- (void)setDeviceInterfaceOrientation:(UIDeviceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:orientation] forKey:@"orientation"];
    }
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
