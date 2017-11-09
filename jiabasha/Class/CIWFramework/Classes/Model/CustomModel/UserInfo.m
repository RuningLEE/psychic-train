//
//  UserInfo.m
//  weddingBusiness
//
//  Created by GarrettGao on 15/1/9.
//  Copyright (c) 2015年 HunBoHui. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"access_token",            @"token",
            @"token_expire_time",       @"tokenTime",
            @"user",                    @"user",
            @"isCache",                 @"isCache",
            nil];
}


- (void)setUser:(User *)user
{
    if(user){
        if([user isKindOfClass:[User class]]){
            
            //绑定推送用户
            [self bindPushUserWithIsBand:YES withUserId:user.uid];
        }
    }
    _user = user;
}


//将要退出登录
- (void)setIsLoginOut:(BOOL)isLoginOut
{
    _isLoginOut = isLoginOut;
    
    if(isLoginOut){
        //取消对用户的推送绑定
        NSString *userId = DATA_ENV.userInfo.user.uid;
        [self bindPushUserWithIsBand:NO withUserId:userId];
    }
}

/**推送是否绑定用户*/
- (void)bindPushUserWithIsBand:(BOOL)isBand withUserId:(NSString *)userId{
    //在分类中重写该方法，不要直接写在框架中
}

@end
