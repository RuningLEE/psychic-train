//
//  GetSessionRecord.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetSessionRecordRequest.h"
#import "MessageUser.h"
#import "SessionLetter.h"

@implementation GetSessionRecordRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/letter/dialog";
}

- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        //解析数据
        NSArray *arrSession = [data objectForKey:@"data"];
        NSArray *arrSessionModel = [SessionLetter createModelsArrayByResults:arrSession];
        [self.resultDic setValue:arrSessionModel forKey:@"sessionRecordModel"];
    }
}

@end
