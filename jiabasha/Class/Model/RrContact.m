//
//  RrContact.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/15.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "RrContact.h"

@implementation RrContact

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"coordinate",                      @"coordinate",
            @"qq",                              @"qq",
            @"tel",                             @"tel",
            nil];
}

@end
