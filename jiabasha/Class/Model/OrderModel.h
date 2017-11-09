//
//  OrderModel.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"
#import "ShopStore.h"

@interface OrderModel : BaseModel
@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) NSString *reserveId;
@property (strong, nonatomic) ShopStore *store;
@property (strong, nonatomic) NSString *cityId;
@property (strong, nonatomic) NSString *cateId;
@property (strong, nonatomic) NSString *orderStatus;
@property (strong, nonatomic) NSString *orderPrice;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *updateTime;
@property (strong, nonatomic) NSString *reserveTime;
@property (strong, nonatomic) NSString *appealTime;
@property (strong, nonatomic) NSString *remark;
@end
