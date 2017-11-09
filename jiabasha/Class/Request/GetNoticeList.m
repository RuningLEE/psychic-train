//
//  GetNoticeList.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetNoticeList.h"

@implementation GetNoticeList

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
        
        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        
        
        
    }
}

@end
