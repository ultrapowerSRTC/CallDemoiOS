//
//  NSData+Extension.m
//  MiNi-ProgressLib
//
//  Created by wanghaipeng on 2019/5/29.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import "NSData+Extension.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (Extension)


/// sha1加密
- (NSData *)sha1
{
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (unsigned int)self.length, digest);
    
    NSData *result = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    
    return result;
}

/// sha256加密
- (NSData *)sha256 {
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, digest);
    
    NSData *result = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    
    return result;
}

/// md5加密为二进制
- (NSData *)md5
{
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    memset(digest, 0, sizeof(digest));
    
    CC_MD5(self.bytes, (unsigned int)self.length, digest);
    
    NSData *data = [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    
    return data;
}

/// md5加密为字符串
- (NSString *)md5ToString
{
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    memset(md, 0, sizeof(md));
    
    unsigned char *status = CC_MD5(self.bytes, (unsigned int) self.length, md);
    
    NSMutableString *string = [NSMutableString string];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [string appendFormat:@"%02X", status[i] & 0xFF];
    }
    
    return string;
}

/// base64加密为字符串
- (NSString *)base64ToString
{
    return [self base64EncodedStringWithOptions:0];
}

/// json成字典
- (NSDictionary *)jsonToObject
{
    NSError *error = nil;
    //解析JSON
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableLeaves error:&error];
    
    if (error) {
        NSLog(@"jsonToObjectError : %@", error);
        return nil;
    }
    
    return dic;
}

/// 转换为16进制字符串
- (NSString *)turnToString
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

/// 转换为16进制字符串
- (NSString *)turnToHexString
{
    uint8_t *bs = (uint8_t *)self.bytes;
    
    NSMutableString *str = [NSMutableString stringWithCapacity:self.length * 2];
    
    for (int i=0; i<self.length; i++) {
        [str appendFormat:@"%02X", bs[i]];
    }
    
    return str;
}


/// AES128加密解密方法
- (NSData *)aes128EncryptWithKey:(NSString *)key iv:(NSString *)iv
{
    return [self aes128Operation:kCCEncrypt key:key iv:iv];
}

- (NSData *)aes128DecryptWithKey:(NSString *)key iv:(NSString *)iv
{
    return [self aes128Operation:kCCDecrypt key:key iv:iv];
}

- (NSData *)aes128Operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv
{
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    if (iv)
    {
        [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    }
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    
    return nil;
}

- (NSData *)aes128EncryptWithKey:(NSData *)key
{
    const void *keyPtr = key.bytes;
    
    NSUInteger dataLength = self.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode + kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          NULL,
                                          self.bytes,   //dataPtr,
                                          dataLength,   //sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return data;
    }
    
    free(buffer);
    
    return nil;
}


@end
