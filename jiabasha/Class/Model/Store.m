//
//  Store.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "Store.h"

@implementation Store

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"address",                 @"address",
            @"cate_id",                 @"cateId",
            @"city_id",                 @"cityId",
            @"dp_count",                @"dpCount",
            @"dp_order",                @"dpcntOrder",
            @"logo",                    @"logo",
            @"logo_id",                 @"logoId",
            @"score_avg",               @"scoreAvg",
            @"store_id",                @"storeId",
            @"store_name",              @"storeName",
            @"store_sname",             @"storeSname",
            @"verify_cash",             @"verifyCash",
            @"verify_brand",            @"verifyBrand",
            @"uid",                     @"uid",
            @"order_num",               @"orderNum",
            @"cash_count",              @"cashCount",
            @"tel",                     @"tel",
            @"hp_count",                @"hpCount",
            @"dp_rder",                 @"dpOrder",
            @"album_list",              @"albumList",
            @"rate_best",               @"rateBest",
            nil];
}

- (NSString *)orderNum {
    if ([CommonUtil isEmpty:_orderNum]) {
        return @"0";
    } else {
        return _orderNum;
    }
}

- (NSString *)dpOrder {
    if ([CommonUtil isEmpty:_dpOrder]) {
        return @"0";
    } else {
        return _dpOrder;
    }
}

- (NSString *)dpCount {
    if ([CommonUtil isEmpty:_dpCount]) {
        return @"0";
    } else {
        return _dpCount;
    }
}


- (NSString *)scoreAvg {
    if ([CommonUtil isEmpty:_scoreAvg]) {
        return @"0";
    } else {
        return _scoreAvg;
    }
}


- (NSString *)cashCount {
    if ([CommonUtil isEmpty:_cashCount]) {
        return @"0";
    } else {
        return _cashCount;
    }
}
@end
