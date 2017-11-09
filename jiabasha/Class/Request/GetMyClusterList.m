//
//  GetMyClusterList.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetMyClusterList.h"
#import "MyClusterModel.h"

@implementation GetMyClusterList

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/tuan/list";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]) {
        NSArray *arrClusterModel = [MyClusterModel createModelsArrayByResults:[[self.resultDic objectForKey:@"data"] objectForKey:@"data"]];
        [self.resultDic setValue:arrClusterModel forKey:@"arrClusterModel"];
    }
}

@end
