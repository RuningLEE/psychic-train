//
//  AdContent.m
//  jiabasha
//
//  Created by guok on 17/1/16.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "AdContent.h"

@implementation AdContent

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"ad_location_name",        @"adLocationName",
            @"ad_location_ename",       @"adLocationEname",
            @"content_name",            @"contentName",
            @"content_pic_url",         @"contentPicUrl",
            @"content_url",             @"contentUrl",
            nil];
}

@end
