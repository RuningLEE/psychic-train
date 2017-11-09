//
//  Product.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "Product.h"

@implementation Product

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"cate_id",                 @"cateId",
            @"city_id",                 @"cityId",
            @"huiyuanjie",              @"huiyuanjie",
            @"price",                   @"price",
            @"product_id",              @"productId",
            @"product_name",            @"productName",
            @"product_pic_url",         @"productPicUrl",
            @"short_desc",              @"shortDesc",
            @"store_id",                @"storeId",
            @"mall_price",              @"mallPrice",
            @"tuan.max_num",            @"tuanMaxNum",
            @"tuan.tuaning",            @"tuaning",
            @"tuan.order_cnt",          @"tuanOrderCnt",
            @"tuan.price",              @"tuanPrice",
            nil];
}

-(NSString *)productName {
    if ([CommonUtil isEmpty:_productName]) {
        return @"";
    } else {
        return _productName;
    }
}

-(NSString *)price {
    if ([CommonUtil isEmpty:_price]) {
        return @"";
    } else {
        return _price;
    }
}

-(NSString *)mallPrice {
    if ([CommonUtil isEmpty:_mallPrice]) {
        return @"";
    } else {
        return _mallPrice;
    }
}

@end
