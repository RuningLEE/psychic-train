//
//  GetCouponList.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetCouponListRequest.h"
#import "CouponModel.h"

@implementation GetCouponListRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/coupon/list";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]){
        NSArray *arrCoupon = [[self.resultDic objectForKey:@"data"] objectForKey:@"data"];
        NSArray *arrCouponModel = [CouponModel createModelsArrayByResults:arrCoupon];
        [self.resultDic setValue:arrCouponModel forKey:@"arrCoupon"];

        //未使用
        if ([CommonUtil isEmpty:[[self.resultDic objectForKey:@"data"] objectForKey:@"init_count"]]) {
            [self.resultDic setValue:@"未使用(0)" forKey:@"initCount"];
        } else {
            [self.resultDic setValue:[NSString stringWithFormat:@"未使用(%@)",[[self.resultDic objectForKey:@"data"] objectForKey:@"init_count"]] forKey:@"initCount"];
        }
        //已使用
        if ([CommonUtil isEmpty:[[self.resultDic objectForKey:@"data"] objectForKey:@"used_count"]]) {
            [self.resultDic setValue:@"已使用(0)" forKey:@"usedCount"];
        } else {
            [self.resultDic setValue:[NSString stringWithFormat:@"已使用(%@)",[[self.resultDic objectForKey:@"data"] objectForKey:@"used_count"]] forKey:@"usedCount"];
        }
        //已过期
        if ([CommonUtil isEmpty:[[self.resultDic objectForKey:@"data"] objectForKey:@"overdue_count"]]) {
            [self.resultDic setValue:@"已过期(0)" forKey:@"overdueCount"];
        } else {
            [self.resultDic setValue:[NSString stringWithFormat:@"已过期(%@)",[[self.resultDic objectForKey:@"data"] objectForKey:@"overdue_count"]] forKey:@"overdueCount"];
        }
    }
}

@end
