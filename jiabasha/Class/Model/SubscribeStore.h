//
//  SubscribeStore.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"
#import "ShopStore.h"

@interface SubscribeStore : BaseModel
@property (strong, nonatomic) NSString *reserveId;
@property (strong, nonatomic) ShopStore *store;
@property (strong, nonatomic) NSString *cityId;
@property (strong, nonatomic) NSString *cateId;
@property (strong, nonatomic) NSString *reserveStatus;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *appointTime;
@property (strong, nonatomic) NSString *remarks;
@property (strong, nonatomic) NSString *cancelTime;
@property (strong, nonatomic) NSString *reserveType;
@property (strong, nonatomic) NSString *reserveTypeName;
@end
