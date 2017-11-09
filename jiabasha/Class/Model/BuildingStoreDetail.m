//
//  BuildingStoreDetail.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/17.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BuildingStoreDetail.h"

@implementation BuildingStoreDetail

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"store_type",                      @"storeType",
            @"logo_id",                         @"logoId",
            @"store_name",                      @"storeName",
            @"uid",                             @"uid",
            @"store_sname",                     @"storeSName",
            @"ogift",                           @"ogift",
            @"verify",                          @"verify",
            @"store_nickname",                  @"storeNickName",
            @"city_id",                         @"cityId",
            @"brand_id",                        @"brandId",
            @"logo",                            @"logo",
            @"store_id",                        @"storeId",
            @"region_id",                       @"regionId",
            @"address",                         @"address",
            @"tel",                             @"tel",
            @"qq",                              @"qq",
            @"agift",                           @"agift",
            @"cate_id",                         @"cateId",
            @"order_num",                       @"orderNum",
            @"dp_order",                        @"dpOrder",
            @"dp_count",                        @"dpCount",
            @"score_avg",                       @"scoreAvg",
            @"coupon",                          @"coupon",
            @"feature_verify",                  @"featureVerify",
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


@end
