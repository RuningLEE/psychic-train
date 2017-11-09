//
//  Banner.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/4.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "Banner.h"

@implementation Banner

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"city_id",                     @"cityId",
            @"content_title",               @"contentTile",
            @"content_url",                 @"contentUrl",
            @"content_pic_url",             @"contentPicUrl",
            nil];
}

@end
