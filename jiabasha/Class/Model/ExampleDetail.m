//
//  ExampleDetail.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ExampleDetail.h"

@implementation ExampleDetail

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"address",                         @"address",
            @"album_desc",                      @"albumDesc",
            @"album_id",                        @"albumId",
            @"album_name",                      @"albumName",
            @"album_price_text",                @"albumPriceText",
            @"album_setting",                   @"albumSetting",
            @"album_status",                    @"albumStatus",
            @"album_text",                      @"albumText",
            @"album_type",                      @"albumType",
            @"cate_id",                         @"cateId",
            @"child",                           @"child",
            @"city_id",                         @"cityId",
            @"create_time",                     @"createTime",
            @"max_price",                       @"maxPrice",
            @"min_price",                       @"minPrice",
            @"modify_time",                     @"modifyTime",
            @"order_index",                     @"orderIndex",
            @"pic_count",                       @"picCount",
            @"region_id",                       @"regionId",
            @"relate_products",                 @"relateProducts",
            @"show_img_url",                    @"showImgUrl",
            @"store",                           @"store",
            @"store_id",                        @"storeId",
            nil];
}

@end
