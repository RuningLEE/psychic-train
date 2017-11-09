//
//  Letter.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/11.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "Letter.h"

@implementation Letter

- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"letter_id",         @"letterId",
            @"rr_content",        @"rrContent",
            @"content",           @"content",
            @"isread",            @"isread",
            @"send_time",         @"sendTime",
            @"count",             @"count",
            @"unreadCnt",         @"unreadCnt",
            @"from_user",         @"fromUser",
            @"to_user",           @"toUser",
            nil];
}

@end
