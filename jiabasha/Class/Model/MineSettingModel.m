//
//  MineSettingModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/19.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "MineSettingModel.h"

@implementation MineSettingModel
/*
 "for_app": "0",
 "for_expo": "0"  适用场合 0门店 1展会
 */
- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"for_app",    @"forApp",
            @"for_expo",   @"foExpo",
            nil];
}
@end
