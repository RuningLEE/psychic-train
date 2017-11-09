//
//  GetMallProductDetail.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ExampleDetail.h"
#import "GetMallExampleDetailRequest.h"

@implementation GetMallExampleDetailRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/mall/example/detail";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode] || [@"OK" isEqualToString:self.errCode]){
        
        NSDictionary *dataDic = [self.resultDic objectForKey:@"data"];
        
        if (dataDic == nil) {
            return;
        }
        NSArray *arrayList = [NSArray arrayWithObject:dataDic];
        if(arrayList && arrayList.count){
            [self.resultDic setObject:[ExampleDetail createModelsArrayByResults:arrayList] forKey:@"productDetail"];
        }
        
        
    }
}

@end
