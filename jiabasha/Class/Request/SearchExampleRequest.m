//
//  SearchExampleRequest.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "SearchExampleRequest.h"
#import "Example.h"

@implementation SearchExampleRequest

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
            
            if ([data objectForKey:@"total"]) {
                [self.resultDic setValue:[data objectForKey:@"total"] forKey:@"total"];
            }

            NSArray *arrayList = [data objectForKey:@"data"];
            
            if(arrayList && arrayList.count){
                [self.resultDic setObject:[Example createModelsArrayByResults:arrayList] forKey:@"example"];
            }
        }
    }
}

@end
