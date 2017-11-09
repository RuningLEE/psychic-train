//
//  StoreComment.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/7.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "StoreComment.h"

@implementation StoreComment

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"add_time",                    @"addTime",
            @"city_id",                     @"cityId",
            @"defect",                      @"defect",
            @"imgs",                        @"imgs",
            @"merit",                       @"merit",
            @"money",                       @"money",
            @"remark_id",                   @"remarkId",
            @"remark_title",                @"remarkTitle",
            @"rr_content",                  @"rrContent",
            @"score",                       @"score",
            @"store_id",                    @"storeId",
            @"type",                        @"type",
            @"user",                        @"user",
            @"uid",                         @"uid",
            nil];
}
@end
