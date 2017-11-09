//
//  StoreCategory.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "StoreCategory.h"

@implementation StoreCategory

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"scate_id",                @"scateId",
            @"store_id",                @"storeId",
            @"scate_name",              @"scateName",
            nil];
}


@end
