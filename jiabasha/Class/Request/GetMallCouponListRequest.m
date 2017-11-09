//
//  GetMallCouponListRequest.m
//  jiabasha
//
//  Created by guok on 17/1/16.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetMallCouponListRequest.h"
#import "CouponMall.h"

@implementation GetMallCouponListRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/mall/coupon/list";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){

        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        
        if ([data isEqual:[NSNull null]] || data.count == 0) {
            return;
        }
        
        //[self.resultDic setObject:[data objectForKey:@"page"] forKey:KEY_COUPON_PAGE];
        if ([data objectForKey:@"total"]) {
            [self.resultDic setObject:[data objectForKey:@"total"] forKey:KEY_COUPON_TOTAL];
        }
        
        //coupon
        NSArray *arrayList = [data objectForKey:@"data"];
        
        if(arrayList && arrayList.count){
            [self.resultDic setObject:[CouponMall createModelsArrayByResults:arrayList] forKey:KEY_COUPONLIST];
        }
    }
}

@end
