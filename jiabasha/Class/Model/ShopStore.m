//
//  ShopStore.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ShopStore.h"

@implementation ShopStore

- (NSDictionary *)attributeMapDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"store_id",    @"storeId",
            @"store_name",  @"storeName",
            @"logo",        @"logo",
            @"address",     @"address",
            @"tel",         @"tel"
            , nil];
}

@end
