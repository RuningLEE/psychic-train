//
//  CateStore.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CateStore.h"

@implementation CateStore
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"cate_id",             @"cateId",
            @"cate_name",           @"cateName",
            @"cate_ename",          @"cateEname",
            @"sub_cates",           @"subCates",
            nil];
}

@end
