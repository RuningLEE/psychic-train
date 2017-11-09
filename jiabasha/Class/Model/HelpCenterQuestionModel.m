//
//  HelpCenterQuestionModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/17.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "HelpCenterQuestionModel.h"

@implementation HelpCenterQuestionModel
/*
 {"city_id": 110900, "category_id": "4","content_id": "816122809410387968", "content_title": "帮助中心标题1"},
 */
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"city_id",             @"cityId",
            @"category_id",         @"categoryId",
            @"content_id",          @"contentId",
            @"content_title",       @"contentTitle",
            nil];
}

@end
