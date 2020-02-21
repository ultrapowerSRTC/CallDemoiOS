//
//  NSDictionary+Extension.m
//  Compensate
//
//  Created by wanghaipeng on 2018/4/24.
//  Copyright © 2018年 wanghaipeng. All rights reserved.
//

#import "NSDictionary+Extension.h"

#import <objc/runtime.h>

@implementation NSDictionary (Extension)

/// 字典转字符串
- (NSData *)jsonToData
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        NSLog(@"jsonToData faild：%@", error);
        return nil;
    }
    
    return jsonData;
}

/// 字典转字符串
- (NSString *)jsonToStringWithNoOption
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:nil error:&error];
    
    if (error) {
        NSLog(@"jsonToString faild : %@", error);
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/// 字典转字符串
- (NSString *)jsonToString
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        NSLog(@"jsonToString faild : %@", error);
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/// 对象转字典
+ (NSDictionary *)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    
    // 获得属性列表
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    
    for (int i = 0;i < propsCount; i++) {
        
        objc_property_t prop = props[i];
        
        // 获得属性的名称
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        
        // kvc读值
        id value = [obj valueForKey:propName];
        if (value == nil) {
            value = @"";
        } else {
            // 自定义处理数组，字典，其他类
            value = [self getObjectInternal:value];
        }
        
        [dic setObject:value forKey:propName];
    }
    
    return dic;
}

+ (id)getObjectInternal:(id)obj
{
    if ([obj isKindOfClass:[NSString class]] ||
       [obj isKindOfClass:[NSNumber class]] ||
       [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    
    if ([obj isKindOfClass:[NSArray class]]) {
        
        NSArray *objarr = obj;
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int i=0; i<objarr.count; i++) {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        
        return arr;
    }
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *objdic = obj;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString *key in objdic.allKeys) {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        
        return dic;
    }
    
    return [self getObjectData:obj];
}


@end
