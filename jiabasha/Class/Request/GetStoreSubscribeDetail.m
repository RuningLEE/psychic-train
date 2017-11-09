//
//  GetStoreSubscribeDetail.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetStoreSubscribeDetail.h"
#import "SubscribeStore.h"

@implementation GetStoreSubscribeDetail
-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/reserve/store/detail";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]){
        NSArray *arrStore = [[self.resultDic objectForKey:@"data"] objectForKey:@"list"];
        NSArray *arrStoreModel = [SubscribeStore createModelsArrayByResults:arrStore];
        [self.resultDic setValue:arrStoreModel forKey:@"store"];
    }
}
@end
