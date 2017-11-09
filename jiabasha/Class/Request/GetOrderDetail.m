//
//  GetOrderDetail.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetOrderDetail.h"
#import "OrderModel.h"

@implementation GetOrderDetail

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/order/detai";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]){
        NSArray *arrStore = [[self.resultDic objectForKey:@"data"] objectForKey:@"list"];
        NSArray *arrOrderModel = [OrderModel createModelsArrayByResults:arrStore];
        [self.resultDic setValue:arrOrderModel forKey:@"orderModel"];
    }
}

@end
