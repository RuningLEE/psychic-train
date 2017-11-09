//
//  LevelPrices.h
//  jiabasha
//
//  Created by guok on 17/1/17.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface LevelPrices : BaseModel

@property (copy, nonatomic) NSString *priceNew;
@property (copy, nonatomic) NSString *priceOld;
@property (copy, nonatomic) NSString *priceVip;
@property (copy, nonatomic) NSString *priceGold;

- (NSString *)getDisplayPrices;

@end
