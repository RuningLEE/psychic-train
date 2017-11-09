//
//  GetHouseInfoRequest.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/14.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetHouseInfoRequest.h"
#import "HouseInfoModel.h"

@implementation GetHouseInfoRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/house/info/get";
}

- (void)processResult
{
    if ([RESPONSE_OK isEqualToString:self.errCode]) {
        NSDictionary *houseinfoData = [self.resultDic objectForKey:@"data"];
        HouseInfoModel *houseModel = [[HouseInfoModel alloc]initWithDataDic:houseinfoData];
        [self.resultDic setValue:houseModel forKey:@"HouseModel"];
    }
}

@end
