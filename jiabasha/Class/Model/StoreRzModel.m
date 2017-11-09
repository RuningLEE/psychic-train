//
//  StoreRzModel.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/17.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "StoreRzModel.h"

@implementation StoreRzModel

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"honor",               @"honor",
            @"attrs",               @"attrs",
            @"pic_urls",            @"picUrls",
            @"describe",            @"describe",
            nil];
}


@end
