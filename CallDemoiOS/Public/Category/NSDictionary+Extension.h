//
//  NSDictionary+Extension.h
//  Compensate
//
//  Created by wanghaipeng on 2018/4/24.
//  Copyright © 2018年 wanghaipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)


/**
 转化二进制
 */
- (NSData *)jsonToData;

/**
 转化字符串
 
 @return 转化得到的字符串
 */
- (NSString *)jsonToString;

/**
 转化字符串(没有空格和换行的长串)
 */
- (NSString *)jsonToStringWithNoOption;


/**
 对象转字典

 @param obj 需要转化的对象
 */
+ (NSDictionary *)getObjectData:(id)obj;


@end
