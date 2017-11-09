//
//  Decorate.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "Decorate.h"

@implementation Decorate

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"city_id",                     @"cityId",
            @"content_title",               @"contentTitle",
            @"content_pic_url",             @"contentPicUrl",
            @"content_url",                 @"contentUrl",
            nil];
}

@end
