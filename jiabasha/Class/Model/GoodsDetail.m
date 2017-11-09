//
//  GoodsDetail.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GoodsDetail.h"

@implementation GoodsDetail
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"city_id",                 @"city_id",
            @"store_id",                @"store_id",
            @"product_name",            @"product_name",
            @"imgs",                    @"imgs",
            @"price",                   @"price",
            @"mall_price",              @"mall_price",
            @"short_desc",              @"short_desc",
            @"attr",                    @"attr",
            @"store_info",              @"store_info",
            @"coupon",                  @"coupon",
            @"contents",                @"contents",
            @"guess",                   @"guess",
            @"huiyuanjie",              @"huiyuanjie",
            @"product_id",              @"productId",
            @"product_pic_url",         @"productPicUrl",
            @"product_pic_id",          @"productPicId",
            @"tuan",                    @"tuan",
            @"tuan_setting",            @"tuanSetting",
            nil];
}


@end
