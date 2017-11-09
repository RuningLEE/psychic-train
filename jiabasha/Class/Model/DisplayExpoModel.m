//
//  DisplayExpoModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "DisplayExpoModel.h"

@implementation DisplayExpoModel
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"expo_id",            @"expoId",
            @"city_id",            @"cityId",
            @"expo_name",          @"expoName",
            @"start_time",         @"startTime",
            @"stop_time",          @"stopTime",
            @"expo_start_date",          @"expoStartDate",
            nil];
}
@end
