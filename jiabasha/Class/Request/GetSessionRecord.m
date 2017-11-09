//
//  GetSessionRecord.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetSessionRecord.h"
#import "MessageUser.h"
#import "SessionLetter.h"

@implementation GetSessionRecord

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
        MessageUser *user = [[MessageUser alloc]initWithDataDic:data];
        NSArray *arrSession = [data objectForKey:@"list"];
        NSArray *sessionLiset = [SessionLetter createModelsArrayByResults:arrSession];
        [self.resultDic setValue:user forKey:@"messageUser"];
        [self.resultDic setValue:arrSession forKey:@"sessionRecord"];
    }
}

@end
