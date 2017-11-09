//
//  ExchangeCouponRequest.m
//  jiabasha
//
//  Created by guok on 17/1/18.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ExchangeCouponRequest.h"

@implementation ExchangeCouponRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/mall/coupon/exchange";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){

    }
}

@end
