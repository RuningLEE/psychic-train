//
//  HouseInfoModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/14.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "HouseInfoModel.h"

@implementation HouseInfoModel
/*
 uid":"11520278","city_id":110900,"cell":"xx小区","house_area":"11","house_info":{"room":1,"hall":1,"kitchen":1,"bathroom":1
 */
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"uid",                 @"uid",
            @"city_id",             @"cityId",
            @"cell",                @"cell",
            @"house_area",          @"houseArea",
            @"house_info",          @"houseInfo",
            nil];
}
@end
