//
//  MineCouponDescModel.h
//  jiabasha
//
//  Created by zhangzt on 2017/2/24.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"
#import "MineCouponDetailDescModel.h"
#import "MineCouponRangeModel.h"

@interface MineCouponDescModel : BaseModel
@property (strong, nonatomic) MineCouponDetailDescModel *detailedDesc;
@property (strong, nonatomic) MineCouponRangeModel *range;
@end
