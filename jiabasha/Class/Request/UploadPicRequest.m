//
//  UploadPicRequest.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/14.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "UploadPicRequest.h"

@implementation UploadPicRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/upload/image";
}

@end
