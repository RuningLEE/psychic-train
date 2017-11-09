//
//  MineFitmentModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "MineFitmentModel.h"

@implementation MineFitmentModel

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"demand_id",             @"demandId",
            @"city_id",               @"cityId",
            @"cate_id",               @"cateId",
            @"phone",                 @"phone",
            @"name",                  @"name",
            @"demand_data",           @"demandData",
            @"create_time",           @"createTime",
            @"demand_type",           @"demandType",
            nil];
}

@end
