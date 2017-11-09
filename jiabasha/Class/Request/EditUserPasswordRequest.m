//
//  EditUserPasswordRequest.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/14.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "EditUserPasswordRequest.h"

@implementation EditUserPasswordRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/my/edit_user_pwd";
}

@end
