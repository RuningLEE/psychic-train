//
//  InvitationQrModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "InvitationQrModel.h"

@implementation InvitationQrModel
/*
 "uname": "测试1,测试2", 到场用户
 "user_level": "new",    用户等级
 "phone": "188*****888", 用户电话
 "door_number": "中央大厅",  入场门号
 "enter_status": "1",
 "enter_tips": "中国婚博会欢迎您！一天逛不够？\n明日可凭今日订单再次免费入场或购票入场。",
 "qrcode_ticket_str": "100000033"    二维码
 */
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"uname",                  @"uname",
            @"user_level",             @"userLevel",
            @"phone",                  @"phone",
            @"door_number",            @"doorNumber",
            @"enter_status",           @"enterStatus",
            @"qrcode_ticket_str",      @"qrcodeTicketStr",
            @"query_url",              @"queryUrl",
            nil];
}
@end
