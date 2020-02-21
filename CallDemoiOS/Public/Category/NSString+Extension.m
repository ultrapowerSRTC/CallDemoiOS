//
//  NSString+Extension.m
//  Caocao
//
//  Created by wanghaipeng on 2018/3/22.
//  Copyright © 2018年 wanghaipeng. All rights reserved.
//

#import "NSString+Extension.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSObject (Extension)
/** 是否有效的字符串  NSNull等非string对象、空字符串(长度为0))、全空格、"null"、"<null>" 、"(null)" */
- (BOOL)isAvalidString {
    if ([self isKindOfClass:[NSString class]]) {
        NSString * str = (NSString *)self;
        //str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (!str.length) {
            return NO;
        }
        if ([str isEqualToString:@"null"]) {
            return NO;
        }
        if ([str isEqualToString:@"(null)"]) {
            return NO;
        }
        if ([str isEqualToString:@"<null>"]) {
            return NO;
        }
        
        return YES;
    }
    return NO;
}

@end

@implementation NSString (Extension)

/// int转字符串
+ (NSString *)intToString:(int)text {
    return [NSString stringWithFormat:@"%d", text];
}

/// int转字符串
+ (NSString *)integerToString:(NSInteger)text {
    return [NSString stringWithFormat:@"%lu", (unsigned long)text];
}

/**
 long转字符串
 */
+ (NSString *)longToString:(int64_t)text {
    return [NSString stringWithFormat:@"%lld", text];
}

/// 字符串拼接
- (NSString *)append:(NSString *)text {
    if (text && [text isKindOfClass:[NSString class]]) {
        return [self stringByAppendingString:text];
    }
    return [self stringByAppendingString:text];
}

/// 字符串替换
- (NSString *)replace:(NSString *)oldStr with:(NSString *)newStr {
    return [self stringByReplacingOccurrencesOfString:oldStr withString:newStr];
}

/// 字符串切割
- (NSArray *)separatedBy:(NSString *)text {
    return [self componentsSeparatedByString:text];
}

/// url转义
- (NSString *)URLEncodedString {
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

/// 转化成http地址
- (NSString *)turnToHttpUrl
{
    return [@"http://" append:self];
}

/// 转化成https地址
- (NSString *)turnToHttpsUrl
{
    return [@"https://" append:self];
}

/// MD5加密
- (NSString *)md5 {
    const char *cStr = self.UTF8String;
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return  output;
}

/// sha1加密
- (NSString *)sha1 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

/// sha256加密
- (NSString *)sha256 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

/// base64加密
- (NSString *)base64 {
    return [[self turnToUTF8Data] base64EncodedStringWithOptions:0];
}


/// base64加密
- (NSData *)base64ToData {
    return [[NSData alloc] initWithBase64EncodedString:self options:0];;
}

/// base64解密
- (NSString *)base64Decode {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [data turnToString];
}

/// 转换为二进制
- (NSData *)turnToUTF8Data {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

/// 字符串转字典
- (NSDictionary *)jsonToDictionary {
    
    if (!self) {
        return nil;
    }
    
    NSError *error = nil;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[self turnToUTF8Data] options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"json解析失败：%@", error);
        return nil;
    }
    
    return dic;
}


/// 秒数转化时间（hh:MM:ss）
- (NSString *)turnToHHMMSS {
    NSInteger seconds = self.longLongValue;
    NSInteger hour = seconds / 3600;
    NSInteger minute = (seconds % 3600) / 60;
    NSInteger second = seconds % 60;
    
    NSString *time = [NSString stringWithFormat:@"%ld:%ld:%ld", (long)hour, (long)minute, (long)second];
    
    return time;
}

/// 过滤空字符串
- (NSString *)filterEmpty {
    
    if (![self judgeStringIsEmpty]) {
        return @"";
    }
    
    return self;
}

/// 判断是否为空
- (BOOL)judgeStringIsEmpty {
    return [self isAvalidString];
//    if ([self isEqual:[NSNull null]]) {
//        return false;
//    }
//
//    if ([self isEqualToString:@"null"]) {
//        return false;
//    }
//
//    if ([self isEqualToString:@"(null)"]) {
//        return false;
//    }
//
//    if (!self) {
//        return false;
//    }
//
//    if (!self.length) {
//        return false;
//    }
//
//    return true;
}

/// 判断是否为纯数字
- (BOOL)isPureNumbers
{
    if (![self judgeStringIsEmpty]) {
        return false;
    }
    
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    
    return NO;
}

/// 比较时间戳字符串大小
- (BOOL)isSmallerThanTime:(NSString *)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date1 = [dateFormatter dateFromString:self];
    NSTimeInterval interval1 = [date1 timeIntervalSince1970] * 1000;
    
    NSDate *date2 = [dateFormatter dateFromString:time];
    NSTimeInterval interval2 = [date2 timeIntervalSince1970] * 1000;
    
    if (interval1 < interval2) {
        return true;
    }
    
    return false;
}

+ (NSString *)stringWithBool:(BOOL)flag {
    return flag ? @"true" : @"false";
}

+ (NSString *)hexStringWithLongLong:(long long)decimal {
    NSString *hex =@"";
    NSString *letter;
    long long number;
    for (int i = 0; i<9; i++) {
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
            case 10:
                letter =@"A";
                break;
            case 11:
                letter =@"B";
                break;
            case 12:
                letter =@"C";
                break;
            case 13:
                letter =@"D";
                break;
            case 14:
                letter =@"E";
                break;
            case 15:
                letter =@"F";
                break;
            default:
                letter = [NSString stringWithFormat:@"%lld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            break;
        }
    }
    
    return hex;
}

+ (NSString *)urlStringWithDictionary:(NSDictionary *)dic {
    NSMutableString * str = [NSMutableString string];
    NSArray * allkeys = dic.allKeys;
    for (int i = 0; i < allkeys.count; i++) {
        NSString * key = allkeys[i];
        if (i == 0) {
            [str appendFormat:@"%@=%@", key, dic[key]];
        } else {
            [str appendFormat:@"&%@=%@", key, dic[key]];
        }
    }
    return str;
}

@end
