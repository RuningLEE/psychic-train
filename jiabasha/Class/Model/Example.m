//
//  Example.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/4.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "Example.h"

@implementation Example

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"address",                 @"address",
            @"album_id",                @"albumId",
            @"album_name",              @"albumName",
            @"album_text",              @"albumText",
            @"cate_id",                 @"cateId",
            @"city_id",                 @"cityId",
            @"lat",                     @"lat",
            @"lng",                     @"lng",
            @"pic_count",               @"picCount",
            @"show_img_id",             @"showImgId",
            @"show_img_url",            @"showImgUrl",
            @"store_id",                @"storeId",
            @"example_name",            @"exampleName",
            @"example_text",            @"exampleText",
            @"store_logo",              @"storeLogo",
            @"store_name",              @"storeName",
            @"store",                   @"store",
            nil];
}

@end
