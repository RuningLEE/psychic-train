//
//  RequireEvaluateDetailRequest.m
//  jiabasha
//
//  Created by LY123 on 2017/3/21.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "RequireEvaluateDetailRequest.h"

@implementation RequireEvaluateDetailRequest
-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/mall/dp/detail";
}

@end
