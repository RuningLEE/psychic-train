//
//  GetMallDpCommentListRequest.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/7.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "StoreComment.h"
#import "GetMallDpCommentListRequest.h"

@implementation GetMallDpCommentListRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}


-(NSString*)getURI
{
    return @"/mall/dp/list";
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
                [self.resultDic setObject:[StoreComment createModelsArrayByResults:arrayList] forKey:@"storeComment"];
            }
           
        }
        
        
    }
}

@end
