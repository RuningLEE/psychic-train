//
//  GetDisplaySubscribeList.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetDisplaySubscribeListRequest.h"
#import "DisplaySubscribeModel.h"

@implementation GetDisplaySubscribeListRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/reserve/expo/list";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]){
        NSArray *arrDisplay = [[self.resultDic objectForKey:@"data"] objectForKey:@"data"];
        NSArray *arrDisModel = [DisplaySubscribeModel createModelsArrayByResults:arrDisplay];
        [self.resultDic setValue:arrDisModel forKey:@"arrDisModel"];
    }
}

@end
