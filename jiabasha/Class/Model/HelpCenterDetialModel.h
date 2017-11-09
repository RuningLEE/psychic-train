//
//  HelpCenterDetialModel.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/17.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface HelpCenterDetialModel : BaseModel
@property (strong, nonatomic) NSString *cityId;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *contentId;
@property (strong, nonatomic) NSString *contentTitle;
@property (strong, nonatomic) NSString *contentText;
@end
