//
//  BaseRequest.h
//  weddingBusiness
//
//  Created by GarrettGao on 15/1/20.
//  Copyright (c) 2015年 HunBoHui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseRequest : CIWAFBaseDataRequest
- (NSString *)getURI;

/**获取默认的网络请求名称*/
+ (NSString *)getDefaultRequstName;

@end
