//
//  GetFitmentDetailRequest.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetFitmentDetailRequest.h"
#import "MineFitmentModel.h"

@implementation GetFitmentDetailRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/reserve/zx/detail";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]){
        NSDictionary *dicFitment = [self.resultDic objectForKey:@"data"];
        MineFitmentModel *fitmentModel = [[MineFitmentModel alloc]initWithDataDic:dicFitment];
        [self.resultDic setValue:fitmentModel forKey:@"fitmentModel"];
    }
}

@end
