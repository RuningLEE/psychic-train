//
//  GetMallStoreRzRequest.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/17.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "StoreRzModel.h"
#import "GetMallStoreRzRequest.h"

@implementation GetMallStoreRzRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/mall/store/rz";
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
            [self.resultDic setObject:[StoreRzModel createModelsArrayByResults:arrayList] forKey:@"storeRz"];
        }
        
        
    }
}


@end
