//
//  MineCouponRangeModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/24.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "MineCouponRangeModel.h"

@implementation MineCouponRangeModel
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"name",        @"name",
            @"content",     @"content",
            @"data_type",   @"dataType",
            nil];
}
@end
