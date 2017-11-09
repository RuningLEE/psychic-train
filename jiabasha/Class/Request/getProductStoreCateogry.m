//
//  getProductStoreCateogry.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/7.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GoodsDetail.h"
#import "getProductStoreCateogry.h"

@implementation getProductStoreCateogry

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}


-(NSString*)getURI
{
    return @"/mall/product/store_category";
}

- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        
        if([data isKindOfClass:[NSDictionary class]]){
            
            if ([data objectForKey:@"total"] != nil) {
                [self.resultDic setObject:[data objectForKey:@"total"] forKey:@"total"];
            }
            
            
            NSArray *arrayList = [data objectForKey:@"data"];
            
            if(arrayList && arrayList.count){
                [self.resultDic setObject:[GoodsDetail createModelsArrayByResults:arrayList] forKey:@"goodsDetail"];
            }
            
        }
        
        
    }
}


@end
