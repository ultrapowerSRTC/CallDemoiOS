//
//  NSString+Extension.h
//  Caocao
//
//  Created by wanghaipeng on 2018/3/22.
//  Copyright © 2018年 wanghaipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)
/** 是否有效的字符串  NSNull等非string对象、空字符串(长度为0))、全空格、"null"、"<null>" 、"(null)" */
- (BOOL)isAvalidString;
@end

@interface NSString (Extension)


/**
 int转字符串
 */
+ (NSString *)intToString:(int)text;

/**
 integer转字符串
 */
+ (NSString *)integerToString:(NSInteger)text;

/**
 long转字符串
 */
+ (NSString *)longToString:(int64_t)text;

/**
 字符串拼接
 */
- (NSString *)append:(NSString *)text;

/**
 字符串替换
 */
- (NSString *)replace:(NSString *)oldStr with:(NSString *)newStr;

/**
 字符串切割
 */
- (NSArray *)separatedBy:(NSString *)text;

/**
 url转义
 */
- (NSString *)URLEncodedString;

/**
 转化成http地址
 */
- (NSString *)turnToHttpUrl;

/**
 转化成https地址
 */
- (NSString *)turnToHttpsUrl;

/**
 sha1加密
 
 @return 加密后的字符串
 */
- (NSString *)sha1;

/** sha256加密 */
- (NSString *)sha256;

/**
 md5加密
 
 @return 加密后的字符串
 */
- (NSString *)md5;

/**
 base64加密
 */
- (NSString *)base64;

/**
 字符串的base64加密
 */
- (NSData *)base64ToData;

/**
 base64解密
 */
- (NSString *)base64Decode;

/**
 转换为二进制
 */
- (NSData *)turnToUTF8Data;

/**
 字符串转字典
 */
- (NSDictionary *)jsonToDictionary;

/**
 秒数转化时间（hh:MM:ss）
 */
- (NSString *)turnToHHMMSS;

/**
 过滤空字符串
 */
- (NSString *)filterEmpty;

/**
 判断是否为空
 */
- (BOOL)judgeStringIsEmpty;

/**
 判断是否为纯数字
 */
- (BOOL)isPureNumbers;

/**
 比较时间戳字符串大小
 
 @param time 被比较的时间戳
 @return 比较结果 true:time大;false:time小;
 */
- (BOOL)isSmallerThanTime:(NSString *)time;

/** bool转字符串true和false */
+ (NSString *)stringWithBool:(BOOL)flag;

/** 转换为16进制字符串 */
+ (NSString *)hexStringWithLongLong:(long long)decimal;

/** 转换为url参数拼接字符串 */
+ (NSString *)urlStringWithDictionary:(NSDictionary *)dic;

@end
