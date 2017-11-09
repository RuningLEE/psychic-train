//
//  GetRenovationTopicRequest.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/20.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "RenovationTopic.h"
#import "GetRenovationTopicRequest.h"

@implementation GetRenovationTopicRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/topic/list";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode] || [@"OK" isEqualToString:self.errCode]){
        
        NSArray *arrayList = [self.resultDic objectForKey:@"data"];
        
        if (arrayList.count <=0) {
            return;
        }
        
        if(arrayList && arrayList.count){
            [self.resultDic setObject:[RenovationTopic createModelsArrayByResults:arrayList] forKey:@"topic"];
        }
    }
}


@end
