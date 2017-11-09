//
//  DemandModel.h
//  jiabasha
//
//  Created by zhangzt on 2017/2/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface DemandModel : BaseModel
@property (strong, nonatomic) NSString *ip;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *block;
@property (strong, nonatomic) NSString *houseType;
@property (strong, nonatomic) NSString *area;
@property (strong, nonatomic) NSString *city;
@end
