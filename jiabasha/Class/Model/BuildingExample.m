//
//  BuildingExample.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/20.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BuildingExample.h"

@implementation BuildingExample
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"album_name",                  @"albumName",
            @"address",                     @"address",
            @"cate_id",                     @"cateId",
            @"city_id",                     @"cityId",
            @"store_id",                    @"storeId",
            @"album_id",                    @"albumId",
            @"show_img_id",                 @"showImgId",
            @"show_img_url",                @"showImgUrl",
            @"pic_count",                   @"picCount",
            @"lat",                         @"lat",
            @"lng",                         @"lng",
            @"store",                       @"store",
            @"album_text",                  @"albumText",
            nil];
}
@end
