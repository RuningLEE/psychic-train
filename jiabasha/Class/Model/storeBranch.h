//
//  storeBranch.h
//  jiabasha
//
//  Created by 金伟城 on 17/1/16.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"
#import "RrContact.h"

@interface storeBranch : BaseModel
@property (copy ,nonatomic) NSString *storeId;
@property (copy ,nonatomic) NSString *branchId;
@property (copy ,nonatomic) NSString *branchName;  // 商品 名称
@property (copy ,nonatomic) NSString *address;
@property (strong ,nonatomic) RrContact *rrContact;

@end
