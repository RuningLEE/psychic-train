//
//  BuildingExample.h
//  jiabasha
//
//  Created by 金伟城 on 17/1/20.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface BuildingExample : BaseModel

@property (copy ,nonatomic) NSString *albumName;
@property (copy ,nonatomic) NSString *address;
@property (copy ,nonatomic) NSString *cateId;
@property (copy ,nonatomic) NSString *cityId;
@property (copy ,nonatomic) NSString *storeId;
@property (copy ,nonatomic) NSString *albumId;
@property (copy ,nonatomic) NSString *showImgId;
@property (copy ,nonatomic) NSString *showImgUrl;
@property (copy ,nonatomic) NSString *picCount;
@property (copy ,nonatomic) NSString *lat;
@property (copy ,nonatomic) NSString *lng;
@property (copy ,nonatomic) NSDictionary *store;
@property (copy ,nonatomic) NSString *albumText;
@end
