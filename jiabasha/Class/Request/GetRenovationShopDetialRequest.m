//
//  GetRenovationShopDetialRequest.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ProductDetail.h"
#import "GetRenovationShopDetialRequest.h"

@implementation GetRenovationShopDetialRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/mall/product/detail";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        
        //商品详情
        if ([data isKindOfClass:[NSDictionary class]]) {
            [self.resultDic setObject:[[ProductDetail alloc] initWithDataDic:data] forKey:@"productDetail"];
        }
        
//        NSArray *arrayList = [NSArray arrayWithObject:data];
//        if(arrayList && arrayList.count){
//            [self.resultDic setObject:[ProductDetail createModelsArrayByResults:arrayList] forKey:@"productDetail"];
//        }
        
    }
}

@end
