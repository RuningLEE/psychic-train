//
//  MineFitmentModel.h
//  jiabasha
//
//  Created by zhangzt on 2017/2/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"
#import "DemandModel.h"

@interface MineFitmentModel : BaseModel
@property (strong, nonatomic) NSString *demandId;
@property (strong, nonatomic) NSString *cityId;
@property (strong, nonatomic) NSString *cateId;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) DemandModel *demandData;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *demandType;
@end
