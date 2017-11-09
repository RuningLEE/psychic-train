//
//  GetNoticeList.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetNoticeListRequest.h"
#import "SystemNotice.h"

@implementation GetNoticeListRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/notice/list";
}

- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        NSArray *arrNotice = [[self.resultDic objectForKey:@"data"] objectForKey:@"data"];
        NSArray *arrNoticeModel = [SystemNotice createModelsArrayByResults:arrNotice];
        [self.resultDic setValue:arrNoticeModel forKey:@"arrNoticeModel"];
    }
}

@end
