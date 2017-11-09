//
//  ExampleDetail.h
//  jiabasha
//
//  Created by 金伟城 on 17/2/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface ExampleDetail : BaseModel

@property (copy ,nonatomic) NSString *address;
@property (copy ,nonatomic) NSString *albumDesc;
@property (copy ,nonatomic) NSString *albumId;
@property (copy ,nonatomic) NSString *albumName;
@property (copy ,nonatomic) NSString *albumPriceText;
@property (copy ,nonatomic) NSString *albumSetting;
@property (copy ,nonatomic) NSString *albumStatus;
@property (copy ,nonatomic) NSString *albumText;
@property (copy ,nonatomic) NSString *albumType;
@property (copy ,nonatomic) NSString *cateId;
@property (copy ,nonatomic) NSArray  *child;
@property (copy ,nonatomic) NSString *cityId;
@property (copy ,nonatomic) NSString *createTime;
@property (copy ,nonatomic) NSString *maxPrice;
@property (copy ,nonatomic) NSString *minPrice;
@property (copy ,nonatomic) NSString *modifyTime;
@property (copy ,nonatomic) NSString *orderIndex;
@property (copy ,nonatomic) NSString *picCount;
@property (copy ,nonatomic) NSString *regionId;
@property (copy ,nonatomic) NSString *relateProducts;
@property (copy ,nonatomic) NSString *showImgUrl;
@property (copy ,nonatomic) NSDictionary *store;
@property (copy ,nonatomic) NSString *storeId;

@end
