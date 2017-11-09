//
//  InvitaionDetailModel.h
//  jiabasha
//
//  Created by zhangzt on 2017/2/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface InvitaionDetailModel : BaseModel
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *queryUrl;
@end
