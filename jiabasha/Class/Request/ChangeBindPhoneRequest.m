//
//  ChangeBindPhoneRequest.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/15.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ChangeBindPhoneRequest.h"

@implementation ChangeBindPhoneRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/my/change_bind_phone";
}

@end
