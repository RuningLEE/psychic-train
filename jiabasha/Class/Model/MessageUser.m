//
//  MessageUser.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/11.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "MessageUser.h"

@implementation MessageUser

- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"uid",                @"uid",
            @"uname",              @"uname",
            @"face_url",           @"faceUrl",
            @"face_id",            @"faceId",
            nil];
}

@end
