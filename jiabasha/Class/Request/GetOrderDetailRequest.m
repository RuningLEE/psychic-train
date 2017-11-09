//
//  GetOrderDetail.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetOrderDetailRequest.h"
#import "OrderModel.h"

@implementation GetOrderDetailRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/order/detail";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]){
        NSDictionary *dicStore = [self.resultDic objectForKey:@"data"];
        OrderModel *orderModel = [[OrderModel alloc]initWithDataDic:dicStore];
        [self.resultDic setValue:orderModel forKey:@"orderModel"];
    }
}

@end
