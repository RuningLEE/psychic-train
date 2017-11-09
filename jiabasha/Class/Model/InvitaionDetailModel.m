//
//  InvitaionDetailModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "InvitaionDetailModel.h"

@implementation InvitaionDetailModel
/*
 "name": "索票完成",
 "status": 1,
 "desc": "恭喜您，您的杭州第一届家装展的门票预定信息已经提交。"
 */
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"name",                 @"name",
            @"status",             @"status",
            @"desc",                @"desc",
            @"query_url",                @"queryUrl",
            nil];
}
@end
