//
//  GetHelpCenter.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetHelpCenterRequest.h"
#import "HelpCenterDetialModel.h"

@implementation GetHelpCenterRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/help/detail";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]) {
        NSDictionary *dicDetail = [[self.resultDic objectForKey:@"data"] firstObject];
        HelpCenterDetialModel *detailModel = [[HelpCenterDetialModel alloc]initWithDataDic:dicDetail];
        [self.resultDic setValue:detailModel forKey:@"detailModel"];
    }
}

@end
