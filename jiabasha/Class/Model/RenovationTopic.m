//
//  RenovationTopic.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/20.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "RenovationTopic.h"

@implementation RenovationTopic

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"city_id",                     @"cityId",
            @"topic_pic_url",               @"topicPicUrl",
            @"topic_url",                   @"topicUrl",
            @"product",                     @"product",
            nil];
}



@end
