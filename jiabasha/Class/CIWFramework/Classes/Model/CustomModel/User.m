//
//  User.m
//  weddingBusiness
//
//  Created by GarrettGao on 15/1/9.
//  Copyright (c) 2015年 HunBoHui. All rights reserved.
//

#import "User.h"

@implementation User
/*
 "uid": "12659722",  用户uid
 "uname": "史颖",  用户昵称
 "user_level":"new", 用户等级
 "last_login_time": "2017-01-04 09:31:54", 最后一次登录时间
 "score": "0",
 "qrcode_img" : "NDE1MjY1Njk=", 二维码
 "email": "",    邮箱地址
 "phone": "18201631471", 电话
 "city_id": "110900",    城市id
 "face_id": "0"   用户头像id
 
 
 /*
 "auto_login_key" = "";
 "bind_status" = 5;
 "create_time" = 1486961849;
 "last_login_ip" = "183.129.158.202";
 qq = 0;
 "real_name" = "";
 reason = "";
 regip = "183.129.158.202";
 source = 9;
 status = 1;
 "user_extra" = "";
 "" = new;
 */

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"uid",                @"uid",
            @"uname",              @"uname",
            @"user_level",         @"userLevel",
            @"last_login_time",    @"lastLoginTime",
            @"score",              @"score",
            @"qrcode_img",         @"qrcodeImg",
            @"email",              @"email",
            @"phone",              @"phone",
            @"city_id",            @"cityId",
            @"face_id",            @"faceId",
            @"face_url",           @"faceUrl",
            @"auto_login_key",     @"autoLoginKey",
            @"bind_status",        @"bindStatus",
            @"create_time",        @"createTime",
            @"last_login_ip",      @"lastLoginIp",
            @"qq",                 @"qq",
            @"real_name",          @"realName",
            @"reason",             @"reason",
            @"regip",              @"regip",
            @"source",             @"source",
            @"status",             @"status",
            @"user_extra",         @"userExtra",
            @"unread_message_cnt",         @"unreadMessageCnt",
            @"sign_in_text",         @"signInText",
            @"sign_in_url",         @"signInUrl",
            @"huiyuanjie_order",         @"huiyuanjieOrder",
            nil];
}

//- (NSDictionary *)attributeMapDictionary{
//    return [NSDictionary dictionaryWithObjectsAndKeys:
//            @"all_score",   @"allScore",
//            @"bwc_score",   @"bwcScore",
//            @"bw_yc_score", @"bwcYcScore",
//            @"yc_score",    @"ptYcScore",
//            @"avatar",      @"headImages",
//            @"uid",         @"userId",
//            @"uname",       @"name",
//            @"bind_status", @"bindStatus",
//            @"phone",       @"phone",
//            @"source",      @"source",
//            @"u_level",     @"uLevel",
//            @"qrcode_img",  @"qrcodeImg",
//            @"u_level_url", @"uLevelUrl",
//            @"live_city",   @"liveCity",    
//            @"gender",      @"gender",
//            @"qq",          @"qq",
//            nil];
//}
//
//- (NSString *)headSmall{
//    return [_headImages objectForKey:@"small"];
//}
//
//- (NSString *)headBig{
//    return [_headImages objectForKey:@"medium"];
//}
//
//- (NSString *)headOrigin{
//    return [_headImages objectForKey:@"origin"];
//}

//- (NSString *)myBgImageSmall{
//    if (_myBgImages.count > 0) {
//        return [_myBgImages[0] objectForKey:@"small"];
//    }
//    return @"";
//}
//
//- (NSString *)myBgImageBig{
//    if (_myBgImages.count > 0) {
//        return [_myBgImages[0] objectForKey:@"medium"];
//    }
//    return @"";
//}
//
//- (NSString *)myBgImageOrigin{
//    if (_myBgImages.count > 0) {
//        return [_myBgImages[0] objectForKey:@"origin"];
//    }
//    return @"";
//}


@end
