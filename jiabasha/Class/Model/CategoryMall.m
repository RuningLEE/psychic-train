//
//  CategoryMall.m
//  jiabasha
//
//  Created by guok on 17/1/16.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CategoryMall.h"

@implementation CategoryMall

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"cate_id",             @"cateId",
            @"cate_name",           @"cateName",
            @"cate_ename",          @"cateEname",
            nil];
}

@end
