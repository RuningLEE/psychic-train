//
//  GetUserStoreListRequest.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/21.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetUserStoreListRequest.h"
#import "ShopStore.h"

@implementation GetUserStoreListRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/order/store_list";
}

- (void)processResult
{
    NSMutableArray *arrStore = [self.resultDic objectForKey:@"data"];
    if (arrStore.count) {
        NSArray *arrStoreModel = [ShopStore createModelsArrayByResults:arrStore];
        [self.resultDic setValue:arrStoreModel forKey:@"arrStoreModel"];
    }
}
@end
