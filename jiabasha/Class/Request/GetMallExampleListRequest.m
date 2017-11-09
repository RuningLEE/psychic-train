//
//  GetMallExampleListRequest.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/7.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BuildingExample.h"
#import "GetMallExampleListRequest.h"

@implementation GetMallExampleListRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}


-(NSString*)getURI
{
    return @"/mall/example/list";
}

- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        
        if([data isKindOfClass:[NSDictionary class]]){
            
            if([CommonUtil isEmpty:[data objectForKey:@"total"] ]){
                [self.resultDic setObject:@"0" forKey:@"total"];
            }else{
                [self.resultDic setObject:[data objectForKey:@"total"] forKey:@"total"];
            }
            
            NSArray *arrayList = [data objectForKey:@"data"];
            
            if(arrayList && arrayList.count){
                [self.resultDic setObject:[BuildingExample createModelsArrayByResults:arrayList] forKey:@"example"];
            }
            
        }
        
        
    }
}


@end
