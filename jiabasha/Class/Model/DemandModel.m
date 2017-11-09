//
//  DemandModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "DemandModel.h"

@implementation DemandModel
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"ip",             @"ip",
            @"store_name",     @"storeName",
            @"block",          @"block",
            @"house_type",     @"houseType",
            @"area",           @"area",
            @"city",           @"city",
            nil];
}

@end
