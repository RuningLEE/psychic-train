//
//  CouponMall.m
//  jiabasha
//
//  Created by guok on 17/1/17.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CouponMall.h"
#import "Product.h"

@implementation CouponMall

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"cash_coupon_id",          @"cashCouponId",
            @"cate_id",                 @"cateId",
            @"end_time",                @"endTime",
            @"exchange_limit",          @"exchangeLimit",
            @"exchange_type",           @"exchangeType",
            @"img_url",                 @"imgUrl",
            @"level_prices",            @"levelPrices",
            @"meet_rule",               @"meetRule",
            @"receive_count",           @"receiveCount",
            @"score",                   @"score",
            @"start_time",              @"startTime",
            @"store_id",                @"storeId",
            @"store_name",              @"storeName",
            @"success_desc",            @"successDesc",
            @"summary",                 @"summary",
            @"title",                   @"title",
            @"total_count",             @"totalCount",
            @"valid_end",               @"validEnd",
            @"valid_start",             @"validStart",
            @"store",                   @"store",
            @"product_list",            @"productList",
            @"desc.range",              @"range",
            @"desc.rules_remind",       @"rulesRemind",
            @"desc.detailed_desc",      @"detailedDesc",
            @"view_money",              @"viewMoney",
            nil];
}

- (NSDictionary *)objectClassInArray {
    return @{@"productList":[Product class]};
}

- (NSString *)receiveCount {
    if ([CommonUtil isEmpty:_receiveCount]) {
        return @"0";
    } else {
        return _receiveCount;
    }
}

- (NSString *)totalCount {
    if ([CommonUtil isEmpty:_totalCount]) {
        return @"0";
    } else {
        return _totalCount;
    }
}

- (NSString *)score {
    if ([CommonUtil isEmpty:_score]) {
        return @"0";
    } else {
        return _score;
    }
}

- (NSString *)viewMoney {
    if ([CommonUtil isEmpty:_viewMoney]) {
        return @"";
    } else {
        return _viewMoney;
    }
}

- (CouponRange *)range {
    if (_range) {
        return _range;
    } else {
        return [CouponRange new];
    }
}

- (CouponRange *)rulesRemind {
    if (_rulesRemind) {
        return _rulesRemind;
    } else {
        return [CouponRange new];
    }
}

- (CouponRange *)detailedDesc {
    if (_detailedDesc) {
        return _detailedDesc;
    } else {
        return [CouponRange new];
    }
}

@end
