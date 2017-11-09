//
//  CouponRange.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/2/14.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CouponRange.h"

@implementation CouponRange

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"name",                @"name",
            @"data_type",           @"dataType",
            @"content",             @"content",
            nil];
}

- (NSString *)content {
    if ([CommonUtil isEmpty:_content]) {
        return @"";
    } else {
        if ([_content isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)_content;
            
            NSString *detail = @"";
            for (NSString *string in array) {
                if (![CommonUtil isEmpty:string]) {
                    if (detail.length > 0) {
                        detail = [NSString stringWithFormat:@"%@\n%@", detail, string];
                    } else {
                        detail = [NSString stringWithFormat:@"%@", string];
                    }
                }
            }
            return detail;
        } else {
            return _content;
        }
    }
}

@end
