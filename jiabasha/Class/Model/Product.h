//
//  Product.h
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface Product : BaseModel

@property (copy ,nonatomic) NSString *cateId;
@property (copy ,nonatomic) NSString *cityId;
@property (strong ,nonatomic) NSNumber *huiyuanjie;
@property (copy ,nonatomic) NSString *price;
@property (copy ,nonatomic) NSString *productId;
@property (copy ,nonatomic) NSString *productName;
@property (copy ,nonatomic) NSString *productPicUrl;
@property (copy ,nonatomic) NSString *shortDesc;
@property (copy ,nonatomic) NSString *storeId;
@property (copy ,nonatomic) NSString *mallPrice;

//tuan 团信息
@property (copy ,nonatomic) NSString *tuanMaxNum;
@property (strong ,nonatomic) NSNumber *tuaning;
@property (copy ,nonatomic) NSString *tuanOrderCnt;
@property (copy ,nonatomic) NSString *tuanPrice;

@end
