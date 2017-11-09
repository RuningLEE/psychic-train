//
//  GetStoreBranchRequest.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/16.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "storeBranch.h"
#import "GetStoreBranchRequest.h"

@implementation GetStoreBranchRequest
-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/mall/store/branch";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        if([CommonUtil isEmpty:[self.resultDic objectForKey:@"data"]]){
             return;
        }
        //category
        NSArray *arrayList = [self.resultDic objectForKey:@"data"];
        if(arrayList && arrayList.count){
            [self.resultDic setObject:[storeBranch createModelsArrayByResults:arrayList] forKey:@"storeBranch"];
        }
        
    }
    
}
@end
