//
//  MineCouponDescModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/24.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "MineCouponDescModel.h"

@implementation MineCouponDescModel
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"range",            @"range",
            @"detailed_desc",    @"detailedDesc",
            nil];
}
@end
