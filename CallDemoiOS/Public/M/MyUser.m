//
//  MyUser.m
//  SRTClibDemo
//
//  Created by wanghaipeng on 2019/9/3.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import "MyUser.h"

@interface MyUser ()

@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation MyUser


#pragma mark -
#pragma mark - 初始化
/// 单例方法
static MyUser *_manager = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}

- (id)copyWithZone:(NSZone *)zone {
    return _manager;
}

- (void)dealloc {
    
}

/// 初始化
- (instancetype) init {
    self = [super init];
    if (self) {
        _defaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *myData = [self getAllMyDatas];
        if (!myData) {
            myData = @{@"address":kAddress,
                       @"type":@"0",
                       @"uccId":@"0",
                       @"appKey":kAppKey,
                       @"appSecret":kAppSecret,
                       @"token":@"",
                       @"nickName":@"",
            };
            [_defaults setObject:myData forKey:kMyUserData];
            [_defaults synchronize];
        }
        
        [self updateObjaAttributes:myData];
    }
    return self;
}

- (void)updateObjaAttributes:(NSDictionary *)dic {
    
    NSString *uccId = [NSString stringWithFormat:@"%@", dic[@"uccId"]];
    
    self.address = [NSString stringWithFormat:@"%@", dic[@"address"]];
    self.uccIdStr = uccId.intValue == 0 ? @"" : uccId;
    self.uccId = [uccId longLongValue];
    self.token = [NSString stringWithFormat:@"%@", dic[@"token"]];
    self.type = [[NSString stringWithFormat:@"%@", dic[@"type"]] intValue];
    self.appKey = [NSString stringWithFormat:@"%@", dic[@"appKey"]];
    self.appSecret = [NSString stringWithFormat:@"%@", dic[@"appSecret"]];
    self.nickName = [NSString stringWithFormat:@"%@", dic[@"nickName"]];
}

- (NSDictionary *)getAllMyDatas {
    NSDictionary *myDatas = [_defaults objectForKey:kMyUserData];
    return myDatas;
}

- (void)updateUserData:(NSDictionary *)dic {
    __block NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:[self getAllMyDatas]];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [tmp setValue:obj forKey:key];
    }];
    [_defaults setValue:tmp forKey:kMyUserData];
    [_defaults synchronize];
    
    [self updateObjaAttributes:tmp];
}

- (void)loginOut {
    [self updateUserData:@{@"uccId":@"",@"nickName":@"",@"token":@""}];
}

@end
