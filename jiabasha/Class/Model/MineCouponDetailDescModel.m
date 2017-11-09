//
//  MineCouponDetailDescModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/24.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "MineCouponDetailDescModel.h"

@implementation MineCouponDetailDescModel
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"content",     @"content",
            @"name",        @"name",
            @"data_type",   @"dataType",
            nil];
}
@end
