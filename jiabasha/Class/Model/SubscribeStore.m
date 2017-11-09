//
//  SubscribeStore.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "SubscribeStore.h"

@implementation SubscribeStore

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"reserve_id",          @"reserveId",
            @"store",               @"store",
            @"city_id",             @"cityId",
            @"cate_id",             @"cateId",
            @"reserve_status",      @"reserveStatus",
            @"create_time",         @"createTime",
            @"appoint_time",        @"appointTime",
            @"remarks",             @"remarks",
            @"cancel_time",         @"cancelTime",
            @"reserve_type",        @"reserveType",
            @"reserve_type_name",   @"reserveTypeName",
            nil];
}

@end
