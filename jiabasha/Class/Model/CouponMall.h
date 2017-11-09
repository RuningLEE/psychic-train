//
//  CouponMall.h
//  jiabasha
//
//  Created by guok on 17/1/17.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"
#import "LevelPrices.h"
#import "MeetRule.h"
#import "Store.h"
#import "CouponRange.h"

@interface CouponMall : BaseModel

@property (copy, nonatomic) NSString *cashCouponId;
@property (copy, nonatomic) NSString *cateId;
@property (copy, nonatomic) NSString *endTime;
@property (copy, nonatomic) NSString *exchangeLimit;
@property (copy, nonatomic) NSString *exchangeType;
@property (copy, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) LevelPrices *levelPrices;
@property (strong, nonatomic) MeetRule *meetRule;
@property (copy, nonatomic) NSString *receiveCount;
@property (copy, nonatomic) NSString *score;
@property (copy, nonatomic) NSString *startTime;
@property (copy, nonatomic) NSString *storeId;
@property (copy, nonatomic) NSString *storeName;
@property (copy, nonatomic) NSString *successDesc;
@property (copy, nonatomic) NSString *summary;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *totalCount;
@property (copy, nonatomic) NSString *validEnd;
@property (copy, nonatomic) NSString *validStart;

//现金券详细
@property (strong, nonatomic) Store *store;
@property (strong, nonatomic) NSArray *productList;
@property (strong, nonatomic) CouponRange *range;
@property (strong, nonatomic) CouponRange *rulesRemind;
@property (strong, nonatomic) CouponRange *detailedDesc;

@property (copy, nonatomic) NSString *viewMoney;

@end
