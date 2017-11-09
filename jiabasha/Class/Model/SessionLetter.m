//
//  SessionLetter.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/11.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "SessionLetter.h"

@implementation SessionLetter
/*
 "letter_id": "3472435", "to_uid": "4561250", "from_uid": "11500911", "content": "你好，请问一下年终奖二等奖里你家提供 的1500元镶钻代金券，是可以直接当现金使用吗? 有没有金额限制?是在今年11月30日之前使用吗?", "isread":
 "0"
 */
- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"letter_id",      @"letterId",
            @"to_uid",         @"toUid",
            @"from_uid",       @"fromUid",
            @"content",        @"content",
            @"isread",         @"isread",
            nil];
}
@end
