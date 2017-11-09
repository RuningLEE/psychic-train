//
//  ProductDetail.h
//  jiabasha
//
//  Created by 金伟城 on 17/2/8.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface TuanSetting : BaseModel

@property (copy ,nonatomic) NSString *begin;
@property (copy ,nonatomic) NSString *end;

@property (copy ,nonatomic) NSArray  *tuanPrices;

@end

@interface TuanPrice : BaseModel

@property (copy ,nonatomic) NSString *num;
@property (copy ,nonatomic) NSString *price;

@end

@interface ProductDetail : BaseModel

@property (copy ,nonatomic) NSDictionary *attr;
@property (copy ,nonatomic) NSDictionary *store;
@property (copy ,nonatomic) NSString *productName;  // 商品 名称
@property (copy ,nonatomic) NSString *shortDesc;
@property (copy ,nonatomic) NSString *mallPrice;
@property (copy ,nonatomic) NSString *huiyuanjie;
@property (copy ,nonatomic) NSString *content;
@property (copy ,nonatomic) NSArray  *guess;
@property (copy ,nonatomic) NSArray  *coupon;
@property (copy ,nonatomic) NSString *cityId;
@property (copy ,nonatomic) NSString *price;
@property (copy ,nonatomic) NSString *productId;
@property (copy ,nonatomic) NSString *storeId;
@property (copy ,nonatomic) NSArray  *imgs;
@property (copy ,nonatomic) NSString *cateId;


//tuan 团信息
@property (copy ,nonatomic) NSString *tuanMaxNum;
@property (strong ,nonatomic) NSNumber *tuaning;
@property (copy ,nonatomic) NSString *tuanOrderCnt;
@property (copy ,nonatomic) NSString *tuanPrice;

@property (strong ,nonatomic) TuanSetting *tuanSetting;

@end

