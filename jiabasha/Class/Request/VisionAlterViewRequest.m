//
//  VisionAlterViewRequest.m
//  jiabasha
//
//  Created by LY123 on 2017/3/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "VisionAlterViewRequest.h"

@implementation VisionAlterViewRequest
-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/update/get";
}

@end
