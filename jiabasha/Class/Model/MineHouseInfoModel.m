//
//  MineHouseInfoModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/14.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "MineHouseInfoModel.h"

@implementation MineHouseInfoModel
/*
 "room":1,"hall":1,"kitchen":1,"bathroom":1}
 */
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"room",              @"room",
            @"hall",              @"hall",
            @"kitchen",           @"kitchen",
            @"bathroom",          @"bathroom",
            nil];
}
@end
