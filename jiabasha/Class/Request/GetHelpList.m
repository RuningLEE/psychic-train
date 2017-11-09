//
//  GetHelpList.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetHelpList.h"

@implementation GetHelpList

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/help/list";
}

@end
