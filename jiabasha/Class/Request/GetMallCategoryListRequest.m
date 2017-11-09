//
//  GetMallCategoryListRequest.m
//  jiabasha
//
//  Created by guok on 17/1/16.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetMallCategoryListRequest.h"
#import "CategoryMall.h"

@implementation GetMallCategoryListRequest

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
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        NSArray *arrayList = [self.resultDic objectForKey:@"data"];
        if(arrayList && arrayList.count){
            [self.resultDic setObject:[CategoryMall createModelsArrayByResults:arrayList] forKey:KEY_CATEGORY];
        }
    }
}

@end
