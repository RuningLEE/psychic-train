//
//  FindMoreRequest.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "FindMoreRequest.h"
#import "FindMore.h"

@implementation FindMoreRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/search/find_more";
}

- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        NSArray *arrayList = [self.resultDic objectForKey:@"data"];
        if(arrayList && arrayList.count){
            [self.resultDic setObject:[FindMore createModelsArrayByResults:arrayList] forKey:@"findmore"];
        }
    }
}

@end
