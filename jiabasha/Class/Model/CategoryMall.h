//
//  CategoryMall.h
//  jiabasha
//
//  Created by guok on 17/1/16.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

//类目
@interface CategoryMall : BaseModel

@property (copy ,nonatomic) NSString *cateId;
@property (copy ,nonatomic) NSString *cateName;
@property (copy ,nonatomic) NSString *cateEname;

@end
