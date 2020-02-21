//
//  NSData+Extension.h
//  MiNi-ProgressLib
//
//  Created by wanghaipeng on 2019/5/29.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Extension)


/**
 sha1加密
 */
- (NSData *)sha1;

/** sha256加密 */
- (NSData *)sha256;

/**
 md5加密
 */
- (NSData *)md5;

/**
 md5加密为字符串
 */
- (NSString *)md5ToString;

/**
 base64加密为字符串
 */
- (NSString *)base64ToString;

/**
 转换为字符串
 */
- (NSString *)turnToString;

/**
 转换为16进制字符串
 */
- (NSString *)turnToHexString;

/**
 json成字典
 */
- (NSDictionary *)jsonToObject;

/**
 AES128加密解密方法
 */
- (NSData *)aes128EncryptWithKey:(NSData *)key;
- (NSData *)aes128DecryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)aes128EncryptWithKey:(NSString *)key iv:(NSString *)iv;


@end

NS_ASSUME_NONNULL_END
