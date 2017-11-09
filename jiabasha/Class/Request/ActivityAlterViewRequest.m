//
//  ActivityAlterViewRequest.m
//  jiabasha
//
//  Created by LY123 on 2017/3/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ActivityAlterViewRequest.h"

@implementation ActivityAlterViewRequest
-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/active/get";
}

@end
