//
//  City.m
//  HunBaSha
//
//  Created by GarrettGao on 15/8/14.
//  Copyright (c) 2015年 hunbohui. All rights reserved.
//

#import "City.h"

@implementation City
/*
'city_id':"",	城市id
'name':"",	城市名称
'sname':"",	城市短名称
'mark':"",	城市英文标识
'host':""	城市对应的网站主机名 */

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"id",                      @"cityId",
            @"name",                    @"name",
            @"sname",                   @"sname",
            @"mark",                    @"mark",
            @"host",                    @"host",
            @"logo",                    @"logo",
            
            
            nil];
}

@end
