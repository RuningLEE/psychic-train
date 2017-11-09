//
//  GetMallCouponDetailRequest.m
//  jiabasha
//
//  Created by guok on 17/1/16.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetMallCouponDetailRequest.h"
#import "CouponMall.h"

@implementation GetMallCouponDetailRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/mall/coupon/detail";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        if([data isKindOfClass:[NSDictionary class]]){
            [self.resultDic setObject:[[CouponMall alloc] initWithDataDic:data] forKey:KEY_COUPONDETAIL];
        }
    }
}

@end
