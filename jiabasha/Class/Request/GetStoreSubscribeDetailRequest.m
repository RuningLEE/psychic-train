//
//  GetStoreSubscribeDetail.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetStoreSubscribeDetailRequest.h"
#import "SubscribeStore.h"

@implementation GetStoreSubscribeDetailRequest
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
        NSDictionary *dicStore = [self.resultDic objectForKey:@"data"];
        SubscribeStore *subscribeStore = [[SubscribeStore alloc]initWithDataDic:dicStore];
        [self.resultDic setValue:subscribeStore forKey:@"storeModel"];
    }
}
@end
