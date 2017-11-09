//
//  GetHelpCenterData.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetHelpCenterDataRequest.h"
#import "HelpCenterQuestionModel.h"
#import "categoryModel.h"

@implementation GetHelpCenterDataRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/help/category";
}

- (void)processResult
{
    NSDictionary *dicQues = [NSDictionary dictionary];
    NSArray *arrTotal = [self.resultDic objectForKey:@"data"];
    if ([RESPONSE_OK isEqualToString:self.errCode]) {
        dicQues = [[self.resultDic objectForKey:@"data"] lastObject];
        NSArray *arrQuesModel = [HelpCenterQuestionModel createModelsArrayByResults:[dicQues objectForKey:@"list"]];
        [self.resultDic setValue:arrQuesModel forKey:@"arrQuesModel"];
        NSArray *arrCategoryModel = [categoryModel createModelsArrayByResults:[dicQues objectForKey:@"category"]];
        [self.resultDic setValue:arrCategoryModel forKey:@"arrCategofyModel"];
    }
}

@end
