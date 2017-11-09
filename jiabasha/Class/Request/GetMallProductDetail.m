//
//  GetMallProductDetail.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetMallProductDetail.h"

@implementation GetMallProductDetail

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/mall/product/detail ";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode] || [@"OK" isEqualToString:self.errCode]){
        
//        NSArray *arrayList = [self.resultDic objectForKey:@"data"];
//        
//        if (arrayList.count <=0) {
//            return;
//        }
//        
//        if(arrayList && arrayList.count){
//            [self.resultDic setObject:[ProductDetail createModelsArrayByResults:arrayList] forKey:@"productDetail"];
//        }
//        
        
    }
}

@end
