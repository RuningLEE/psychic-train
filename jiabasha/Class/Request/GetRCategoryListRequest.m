//
//  GetMallCategoryList Request.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CateStore.h"
#import "GetRCategoryListRequest.h"

@implementation GetRCategoryListRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/mall/category/list";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode] || [@"OK" isEqualToString:self.errCode]){
        
        NSArray *arrayList = [self.resultDic objectForKey:@"data"];
        
        if (arrayList.count <=0) {
            return;
        }
        
        if(arrayList && arrayList.count){
            [self.resultDic setObject:[CateStore createModelsArrayByResults:arrayList] forKey:@"cateStore"];
        }
        
        
    }
}

@end
