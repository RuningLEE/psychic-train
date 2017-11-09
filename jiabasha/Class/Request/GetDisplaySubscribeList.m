//
//  GetDisplaySubscribeList.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetDisplaySubscribeList.h"
#import "DisplaySubscribeModel.h"

@implementation GetDisplaySubscribeList

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
        NSArray *arrdisplay = [[self.resultDic objectForKey:@"data"] objectForKey:@"list"];
        NSArray *arrDisModel = [DisplaySubscribeModel createModelsArrayByResults:arrdisplay];
        [self.resultDic setValue:arrDisModel forKey:@"arrDisModel"];
    }
}

@end
