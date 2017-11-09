//
//  Store.h
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface Store : BaseModel

@property (copy ,nonatomic) NSString *address;
@property (copy ,nonatomic) NSString *cateId;
@property (copy ,nonatomic) NSString *cityId;
@property (copy ,nonatomic) NSString *dpCount;
@property (copy ,nonatomic) NSString *dpcntOrder;
@property (copy ,nonatomic) NSString *logo;
@property (copy ,nonatomic) NSString *logoId;
@property (copy ,nonatomic) NSArray *albumList;
@property (copy ,nonatomic) NSString *scoreAvg;
@property (copy ,nonatomic) NSString *storeId;
@property (copy ,nonatomic) NSString *storeName;
@property (copy ,nonatomic) NSString *storeSname;
@property (copy ,nonatomic) NSString *verifyCash;
@property (copy ,nonatomic) NSString *verifyBrand;
@property (copy ,nonatomic) NSString *uid;
@property (copy ,nonatomic) NSString *orderNum;
@property (copy ,nonatomic) NSString *cashCount;
@property (copy ,nonatomic) NSString *dpOrder;//点评数


//现金券详细字段
@property (copy ,nonatomic) NSString *tel;
@property (copy ,nonatomic) NSString *hpCount;

@property (copy ,nonatomic) NSString *rateBest;

@end
