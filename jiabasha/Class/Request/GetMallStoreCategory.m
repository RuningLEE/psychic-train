//
//  GetMallStoreCategory.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "StoreCategory.h"
#import "GetMallStoreCategory.h"

@implementation GetMallStoreCategory

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/mall/store/category";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode] || [@"OK" isEqualToString:self.errCode]){
        
        NSArray *dataArr = [self.resultDic objectForKey:@"data"];

        if(dataArr && dataArr.count){
            [self.resultDic setObject:[StoreCategory createModelsArrayByResults:dataArr] forKey:@"StoreCategory"];
        }
        
        
    }
}


@end
