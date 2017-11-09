//
//  GetHelpList.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetHelpListRequest.h"
#import "HelpCenterQuestionModel.h"

@implementation GetHelpListRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/help/list";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]) {
        NSArray *arrQues = [self.resultDic objectForKey:@"data"];
        if (arrQues.count > 0) {
            NSArray *arrQuesModel = [HelpCenterQuestionModel createModelsArrayByResults:arrQues];
            [self.resultDic setValue:arrQuesModel forKey:@"arrQuesModel"];
        }
    }
}

@end
