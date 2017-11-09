//
//  ImgModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/17.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ImgModel.h"

@implementation ImgModel
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"img_id",                 @"imgId",
            @"img_url",                 @"imgUrl",
            nil];
}
@end
