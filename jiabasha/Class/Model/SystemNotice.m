//
//  SystemNotice.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "SystemNotice.h"

@implementation SystemNotice

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"system_notice_id",     @"noticeId",
            @"content",              @"content",
            @"isread",               @"isread",
            @"send_time",            @"sendTime",
            @"item_type",            @"itemType",
            @"send_uid",             @"sendUid",
            @"send_uname",           @"sendUname",
            nil];
}
@end
