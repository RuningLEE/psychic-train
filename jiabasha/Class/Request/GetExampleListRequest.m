//
//  GetExampleListRequest.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/20.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BuildingExample.h"
#import "GetExampleListRequest.h"

@implementation GetExampleListRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}


-(NSString*)getURI
{
    return @"/common/search/example";
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
            
            NSDictionary *tagMap = [NSDictionary dictionaryWithDictionary:data[@"tag_map"]];
            if (tagMap != nil ) {
                [self.resultDic setObject:tagMap forKey:@"tagMap"];
            }
            NSDictionary *attrMap = [NSDictionary dictionaryWithDictionary:data[@"attr_map"]];
            if (tagMap != nil ) {
                [self.resultDic setObject:attrMap forKey:@"attrMap"];
            }
        }
        
    
    }
}

@end
