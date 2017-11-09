//
//  StoreComment.h
//  jiabasha
//
//  Created by 金伟城 on 17/2/7.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface StoreComment : BaseModel

@property (copy ,nonatomic) NSString *addTime;
@property (copy ,nonatomic) NSString *cityId;
@property (copy ,nonatomic) NSString *defect;
@property (copy ,nonatomic) NSArray  *imgs;
@property (copy ,nonatomic) NSString *merit;
@property (copy ,nonatomic) NSString *money;
@property (copy ,nonatomic) NSString *remarkId;
@property (copy ,nonatomic) NSString *remarkTitle;
@property (copy ,nonatomic) NSString *rrContent;
@property (copy ,nonatomic) NSString *score;
@property (copy ,nonatomic) NSString *storeId;
@property (copy ,nonatomic) NSString *type;
@property (copy ,nonatomic) NSDictionary *user;
@property (copy ,nonatomic) NSString *uid;

@end
