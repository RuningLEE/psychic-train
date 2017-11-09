//
//  FindMore.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "FindMore.h"

@implementation FindMore

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"city_id",              @"cityId",
            @"content_title",         @"contentTile",
            @"content_url",          @"contentUrl",
            nil];
}

@end
