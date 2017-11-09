//
//  HouseInfoModel.h
//  jiabasha
//
//  Created by zhangzt on 2017/2/14.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"
#import "MineHouseInfoModel.h"

@interface HouseInfoModel : BaseModel

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *cityId;
@property (strong, nonatomic) NSString *cell;
@property (strong, nonatomic) NSString *houseArea;
@property (strong, nonatomic) MineHouseInfoModel *houseInfo;
@end
