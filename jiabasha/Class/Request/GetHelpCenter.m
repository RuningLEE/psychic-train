//
//  GetHelpCenter.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetHelpCenter.h"

@implementation GetHelpCenter

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/help/detail";
}

@end