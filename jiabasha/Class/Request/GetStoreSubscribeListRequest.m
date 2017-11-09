//
//  GetStoreSubscribeList.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetStoreSubscribeListRequest.h"
#import "SubscribeStore.h"

@implementation GetStoreSubscribeListRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/reserve/store/list";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]){
        NSDictionary *dicStore = [self.resultDic objectForKey:@"data"];
        NSArray *arrStoreModel = [SubscribeStore createModelsArrayByResults:[dicStore objectForKey:@"data"]];
        [self.resultDic setValue:arrStoreModel forKey:@"arrStore"];
    }
}

@end
