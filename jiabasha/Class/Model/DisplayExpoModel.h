//
//  DisplayExpoModel.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface DisplayExpoModel : BaseModel
@property (strong, nonatomic) NSString *expoId;
@property (strong, nonatomic) NSString *cityId;
@property (strong, nonatomic) NSString *expoName;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *stopTime;
@property (strong, nonatomic) NSString *expoStartDate;
@end
