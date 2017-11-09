//
//  GetCommonTopicList.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/15.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetCommonTopicList.h"
#import "CommonTopicModel.h"

@implementation GetCommonTopicList

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
    if([RESPONSE_OK isEqualToString:self.errCode]) {
        NSArray *topicList = [self.resultDic objectForKey:@"data"];
        
        if(topicList && topicList.count){
            NSArray *topicModelArr = [CommonTopicModel createModelsArrayByResults:topicList];
            [self.resultDic setValue:topicModelArr forKey:@"topicArr"];
        }
    }
}

@end
