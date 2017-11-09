//
//  AddKeziRequest.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/2/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "AddKeziRequest.h"

@implementation AddKeziRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/mall/kezi/add";
}

- (void)processResult
{
}

@end
