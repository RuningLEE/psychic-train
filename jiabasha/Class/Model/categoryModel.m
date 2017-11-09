//
//  categoryModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/25.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "categoryModel.h"

@implementation categoryModel
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"id",             @"categoryId",
            @"category_name",         @"categoryName",
            nil];
}
@end
