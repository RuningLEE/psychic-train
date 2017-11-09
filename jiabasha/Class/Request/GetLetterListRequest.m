//
//  GetLetterList.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/11.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetLetterListRequest.h"
#import "Letter.h"

@implementation GetLetterListRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/letter/list";
}

- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        NSArray *arrLetter = [[self.resultDic objectForKey:@"data"] objectForKey:@"data"];
        //解析数据
        NSArray *arrLetterModel = [Letter createModelsArrayByResults:arrLetter];
        [self.resultDic setValue:arrLetterModel forKey:@"arrLetterModel"];
    }
}

@end
