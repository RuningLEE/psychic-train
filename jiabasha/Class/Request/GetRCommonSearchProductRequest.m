//
//  GetRCommonSearchProductRequest.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GoodsDetail.h"
#import "GetRCommonSearchProductRequest.h"

@implementation GetRCommonSearchProductRequest

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
                [self.resultDic setObject:[GoodsDetail createModelsArrayByResults:arrayList] forKey:@"goods"];
            }
        }
    }
}

@end
