//
//  GetBuildingStoreDetailRequest.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/17.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BuildingStoreDetail.h"
#import "GetBuildingStoreDetailRequest.h"

@implementation GetBuildingStoreDetailRequest
-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/mall/store/detail";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode] || [@"OK" isEqualToString:self.errCode]){
        
        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        if (data == nil) {
            return;
        }
        //category
        NSArray *arrayList = [NSArray arrayWithObject:data];
        if(arrayList && arrayList.count){
            [self.resultDic setObject:[BuildingStoreDetail createModelsArrayByResults:arrayList] forKey:@"BuildingStoreDetail"];
        }
        
    }
    
}
@end
