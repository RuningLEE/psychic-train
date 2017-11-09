//
//  GetCityListRequest.m
//  HunBaSha
//
//  Created by GarrettGao on 15/6/12.
//  Copyright (c) 2015年 hunbohui. All rights reserved.
//

#import "GetCityListRequest.h"
#import "CIWGobalPaths.h"

@implementation GetCityListRequest

- (CIWRequestMethod)getRequestMethod{
    return CIWRequestMethodPost;//设置请求方式
}

- (NSString *)getURI{
    return @"/common/city/list";//获取城市列表api
}

- (void)processResult{
    // 这里处理网络请求的解析
    NSArray *arrayList = [self.resultDic objectForKey:@"data"];
    if(arrayList && arrayList.count){
        [self.resultDic setObject:[City createModelsArrayByResults:arrayList] forKey:KEY_MODEL];
    }
}

//- (void)setNetWorkConfig
//{
//    [self.requestOperation waitUntilFinished];
//    self.requestSerializer.timeoutInterval = 20;
//}
@end
