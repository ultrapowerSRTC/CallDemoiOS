//
//  MyUser.h
//  SRTClibDemo
//
//  Created by wanghaipeng on 2019/9/3.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyUser : NSObject


+ (instancetype)sharedInstance;

- (void)updateUserData:(NSDictionary *)dic;
- (void)loginOut;

@property (nonatomic, copy) NSString *address;      // 服务器地址
@property (nonatomic, assign) int64_t uccId;        // 用户id
@property (nonatomic, copy) NSString *uccIdStr;     // 用户id
@property (nonatomic, copy) NSString *token;        // 用户token
@property (nonatomic, assign) int type;             // 用户类型 1:游客 2:注册用户
@property (nonatomic, copy) NSString *appKey;       // appKey
@property (nonatomic, copy) NSString *appSecret;    // appSecret
@property (nonatomic, copy) NSString *nickName;     //昵称

@end

NS_ASSUME_NONNULL_END
