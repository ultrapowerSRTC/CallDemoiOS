
#import <Foundation/Foundation.h>

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"{\n"];
    
    NSString * space = [self spaceWithLevel:level];
    NSString * subSpace = [NSString stringWithFormat:@"%@\t", space];
    
    // 遍历字典的所有键值对
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [str appendFormat:@"%@\"%@\":\"%@\",\n", subSpace, key, [(NSString *)obj stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        } else {
            if ([obj respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
                [str appendFormat:@"%@\"%@\":%@,\n", subSpace, key, [obj descriptionWithLocale:locale indent:level + 1]];
            } else {
                [str appendFormat:@"%@\"%@\":%@,\n", subSpace, key, obj];
            }
        }
    }];
    
    [str appendFormat:@"%@}", space];
    
    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    
    return str;
}

- (NSString *)spaceWithLevel:(NSUInteger)level {
    NSMutableString *mustr = [[NSMutableString alloc] init];
    for (int i=0; i<level; i++) {
        [mustr appendString:@"\t"];
    }
    return mustr;
}

@end

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"[\n"];
    
    NSString * space = [self spaceWithLevel:level];
    NSString * subSpace = [NSString stringWithFormat:@"%@\t", space];
    
    // 遍历数组的所有元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [str appendFormat:@"%@\"%@\",\n", subSpace, [(NSString *)obj stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        } else {
            if ([obj respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
                [str appendFormat:@"%@%@,\n", subSpace, [obj descriptionWithLocale:locale indent:level+1]];
            } else {
                [str appendFormat:@"%@%@,\n", subSpace, obj];
            }
        }
    }];
    
    [str appendFormat:@"%@]", space];
    
    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    
    return str;
}

- (NSString *)spaceWithLevel:(NSUInteger)level {
    NSMutableString *mustr = [[NSMutableString alloc] init];
    for (int i=0; i<level; i++) {
        [mustr appendString:@"\t"];
    }
    return mustr;
}

@end
