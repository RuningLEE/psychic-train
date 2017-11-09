//
//  OrderModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"order_id",           @"orderId",
            @"reserve_id",         @"reserveId",
            @"store",              @"store",
            @"city_id",            @"cityId",
            @"cate_id",            @"cateId",
            @"order_status",       @"orderStatus",
            @"order_price",        @"orderPrice",
            @"phone",              @"phone",
            @"name",               @"name",
            @"create_time",        @"createTime",
            @"update_time",        @"updateTime",
            @"reserve_time",       @"reserveTime",
            @"appeal_time",        @"appealTime",
            @"remark",             @"remark",
            nil];
}

@end
