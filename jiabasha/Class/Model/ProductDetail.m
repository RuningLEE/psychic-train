//
//  ProductDetail.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/8.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ProductDetail.h"

@implementation ProductDetail

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"attr",                    @"attr",
            @"store",                   @"store",
            @"product_name",            @"productName",
            @"short_desc",              @"shortDesc",
            @"mall_price",              @"mallPrice",
            @"huiyuanjie",              @"huiyuanjie",
            @"guess",                   @"guess",
            @"coupon",                  @"coupon",
            @"city_id",                 @"cityId",
            @"price",                   @"price",
            @"product_id",              @"productId",
            @"store_id",                @"storeId",
            @"imgs",                    @"imgs",
            @"cate_id",                 @"cateId",
            @"content",                 @"content",
            @"tuan.max_num",            @"tuanMaxNum",
            @"tuan.tuaning",            @"tuaning",
            @"tuan.order_cnt",          @"tuanOrderCnt",
            @"tuan.price",              @"tuanPrice",
            @"tuan_setting",            @"tuanSetting",
            nil];
}

- (TuanSetting *)tuanSetting {
    if (_tuanSetting) {
        return _tuanSetting;
    } else {
        return [TuanSetting new];
    }
}

- (NSString *)tuanOrderCnt {
    if (_tuanOrderCnt) {
        return _tuanOrderCnt;
    } else {
        return @"0";
    }
}

- (NSString *)tuanMaxNum {
    if (_tuanMaxNum) {
        return _tuanMaxNum;
    } else {
        return @"0";
    }
}

- (NSString *)price {
    if (_price) {
        return _price;
    } else {
        return @"";
    }
}

- (NSString *)mallPrice {
    if (_mallPrice) {
        return _mallPrice;
    } else {
        return @"";
    }
}

@end

@implementation TuanSetting

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"begin",           @"begin",
            @"end",             @"end",
            @"tuan",            @"tuanPrices",
            nil];
}

- (NSDictionary *)objectClassInArray {
    return @{@"tuanPrices":[TuanPrice class]};
}

- (NSArray *)tuanPrices {
    if (_tuanPrices) {
        return _tuanPrices;
    } else {
        return [NSArray new];
    }
}

@end

@implementation TuanPrice

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"num",             @"num",
            @"price",           @"price",
            nil];
}

@end
