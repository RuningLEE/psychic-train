//
//  Example.h
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/4.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"
#import "Store.h"

@interface Example : BaseModel

@property (copy ,nonatomic) NSString *address;
@property (copy ,nonatomic) NSString *albumId;
@property (copy ,nonatomic) NSString *albumName;
@property (copy ,nonatomic) NSString *albumText;
@property (copy ,nonatomic) NSString *cateId;
@property (copy ,nonatomic) NSString *cityId;
@property (copy ,nonatomic) NSString *lat;
@property (copy ,nonatomic) NSString *lng;
@property (copy ,nonatomic) NSString *picCount;
@property (copy ,nonatomic) NSString *showImgId;
@property (copy ,nonatomic) NSString *showImgUrl;
@property (copy ,nonatomic) NSString *storeId;

@property (strong, nonatomic) Store *store;

@property (copy ,nonatomic) NSString *exampleName;
@property (copy ,nonatomic) NSString *exampleText;
@property (copy ,nonatomic) NSString *storeLogo;
@property (copy ,nonatomic) NSString *storeName;

@end
