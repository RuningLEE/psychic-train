//
//  GetStoreAddReserveRequest.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/15.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetStoreAddReserveRequest.h"

@implementation GetStoreAddReserveRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/mall/store/add_reserve";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode] || [@"OK" isEqualToString:self.errCode]){
    
        
        
    }
}


@end
