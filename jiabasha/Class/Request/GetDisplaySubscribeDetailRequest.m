//
//  GetDisplaySubscribeDetail.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetDisplaySubscribeDetailRequest.h"
#import "DisplaySubscribeModel.h"

@implementation GetDisplaySubscribeDetailRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/reserve/expo/detail";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]){
        NSDictionary *dicdisplay = [self.resultDic objectForKey:@"data"];
        DisplaySubscribeModel *DisModel = [[DisplaySubscribeModel alloc]initWithDataDic:dicdisplay];
        [self.resultDic setValue:DisModel forKey:@"DisModel"];
    }
}

@end
