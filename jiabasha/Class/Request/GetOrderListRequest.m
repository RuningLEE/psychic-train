//
//  GetOrderList.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetOrderListRequest.h"
#import "OrderModel.h"

@implementation GetOrderListRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/order/list";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]){
        NSArray *arrStore = [[self.resultDic objectForKey:@"data"] objectForKey:@"data"];
        NSArray *arrOrderModel = [OrderModel createModelsArrayByResults:arrStore];
        [self.resultDic setValue:arrOrderModel forKey:@"arrOrder"];
    }
}

@end
