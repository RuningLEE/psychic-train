//
//  CateStore.h
//  jiabasha
//
//  Created by 金伟城 on 17/2/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface CateStore : BaseModel
@property (copy ,nonatomic) NSString *cateId;
@property (copy ,nonatomic) NSString *cateName;
@property (copy ,nonatomic) NSString *cateEname;
@property (strong ,nonatomic) NSArray *subCates;
@end
