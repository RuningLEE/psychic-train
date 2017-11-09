//
//  GetLetterList.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/11.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetLetterList.h"
#import "Letter.h"

@implementation GetLetterList

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
        
        NSArray *data = [self.resultDic objectForKey:@"data"];
        //解析数据
        NSArray *arrLetter = [Letter createModelsArrayByResults:data];
        [self.resultDic setValue:arrLetter forKey:@"letter_list"];
    }
}

@end
