//
//  SearchProductRequest.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "SearchProductRequest.h"
#import "Product.h"

@implementation SearchProductRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/search/product";
}

- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        
        if([data isKindOfClass:[NSDictionary class]]){
            
            if ([data objectForKey:@"total"]) {
                [self.resultDic setObject:[data objectForKey:@"total"] forKey:@"total"];
            }
            
            NSArray *arrayList = [data objectForKey:@"data"];
            
            if(arrayList && arrayList.count){
                [self.resultDic setObject:[Product createModelsArrayByResults:arrayList] forKey:@"product"];
            }
        }
    }
}

@end
