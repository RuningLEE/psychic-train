//
//  CancelDisplaySubscribe.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CancelDisplaySubscribe.h"

@implementation CancelDisplaySubscribe

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/reserve/expo/cancel";
}

@end