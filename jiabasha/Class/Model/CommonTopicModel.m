//
//  CommonTopicModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/15.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CommonTopicModel.h"

@implementation CommonTopicModel

/*
 "city_id":100010,
 "topic_pic_url":"http://3.tthunbohui.cn/n/00402VMG00bx1FMFD0E01A8.jpg",
 "topic_url":"http://bj.jiehun.com.cn",
*/
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"city_id",                 @"cityId",
            @"topic_pic_url",           @"topicPicUrl",
            @"topic_url",               @"topicUrl",
            nil];
}
@end
