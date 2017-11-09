//
//  AppInstallRequest.h
//  HunBaSha
//
//  Created by GarrettGao on 16/6/13.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "BaseRequest.h"

@interface AppInstallRequest : BaseRequest

/**注册app请求*/
+ (void)installRequest;

/**所有请求参数*/
+ (NSMutableDictionary *)getParameter;



@end
