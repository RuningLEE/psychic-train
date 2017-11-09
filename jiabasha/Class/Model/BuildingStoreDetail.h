//
//  BuildingStoreDetail.h
//  jiabasha
//
//  Created by 金伟城 on 17/1/17.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"


@interface BuildingStoreDetail : BaseModel
@property (copy ,nonatomic) NSString *storeType;
@property (copy ,nonatomic) NSString *logonId;
@property (copy ,nonatomic) NSString *storeName;
@property (copy ,nonatomic) NSString *uid;
@property (copy ,nonatomic) NSString *storeSName;
@property (copy ,nonatomic) NSDictionary *ogift;
@property (copy ,nonatomic) NSDictionary *verify;
@property (copy ,nonatomic) NSString *storeNickName;
@property (copy ,nonatomic) NSString *cityId;
@property (copy ,nonatomic) NSString *brandId;
@property (copy ,nonatomic) NSString *logo;
@property (copy ,nonatomic) NSString *storeId;
@property (copy ,nonatomic) NSString *regionId;
@property (copy ,nonatomic) NSString *address;
@property (copy ,nonatomic) NSString *tel;
@property (copy ,nonatomic) NSString *qq;
@property (copy ,nonatomic) NSDictionary *agift;
@property (copy ,nonatomic) NSString *cateId;
@property (copy ,nonatomic) NSString *dpOrder;//点评数
@property (copy ,nonatomic) NSString *orderNum;
@property (copy ,nonatomic) NSString *dpCount;
@property (copy ,nonatomic) NSString *scoreAvg;
@property (copy ,nonatomic) NSArray *coupon;
@property (copy ,nonatomic) NSDictionary *featureVerify;
@end
