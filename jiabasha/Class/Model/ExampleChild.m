//
//  ExampleChild.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ExampleChild.h"

@implementation ExampleChild

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"pics",      @"pics",
            @"title",     @"title",
            @"store_id",     @"storeId",
            nil];
}

@end
