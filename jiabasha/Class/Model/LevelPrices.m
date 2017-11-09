//
//  LevelPrices.m
//  jiabasha
//
//  Created by guok on 17/1/17.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "LevelPrices.h"

@implementation LevelPrices

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"vip",             @"priceVip",
            @"new",             @"priceNew",
            @"gold",            @"priceGold",
            @"old",             @"priceOld",
            nil];
}

- (NSString *)getDisplayPrices {
    NSArray *array = [@[self.priceNew, self.priceOld, self.priceVip, self.priceGold] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableString *prices = [NSMutableString string];
    
    NSString *tmpprice = nil;
    for (NSString *price in array) {
        if ([CommonUtil isNotEmpty:price] && ![price isEqualToString:tmpprice]) {
            if (prices.length == 0) {
                [prices appendString:price];
            } else {
                [prices appendFormat:@"-%@", price];
            }
            tmpprice = price;
        }
    }
    
    return prices;
}

@end
