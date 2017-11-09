//
//  ShopStore.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface ShopStore : BaseModel

/*
 "store_name": "周大福",
 "store_sname": "周大福",
 "uid": 11445118,
 "cate_id": 1060,
 "city_id": 110900,
 "logo_id": "0002000774100001df03251a3c04881222",
 "logo": "",

 */
@property (strong, nonatomic) NSString *storeId;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *logo;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *tel;

@end
