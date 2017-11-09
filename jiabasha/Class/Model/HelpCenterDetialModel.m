//
//  HelpCenterDetialModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/17.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "HelpCenterDetialModel.h"

@implementation HelpCenterDetialModel
/*
 "city_id": 110900, "category_id": "4","content_id": "816122809410387968", "content_title": "帮助中心标题1", "content_text": "帮助中心正文1"
 */
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"city_id",             @"cityId",
            @"category_id",         @"categoryId",
            @"content_id",          @"contentId",
            @"content_title",       @"contentTitle",
            @"content_text",        @"contentText",
            nil];
}
@end
