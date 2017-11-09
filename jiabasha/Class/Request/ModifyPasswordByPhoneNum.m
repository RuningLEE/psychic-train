//
//  ModifyPasswordByPhoneNum.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/15.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ModifyPasswordByPhoneNum.h"

@implementation ModifyPasswordByPhoneNum

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/account/edit_user_pwd_by_code";
}

@end
