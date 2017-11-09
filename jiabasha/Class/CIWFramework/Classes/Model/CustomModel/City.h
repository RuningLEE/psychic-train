//
//  City.h
//  HunBaSha
//
//  Created by GarrettGao on 15/8/14.
//  Copyright (c) 2015年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface City : BaseModel

@property (copy ,nonatomic) NSString *cityId;
@property (copy ,nonatomic) NSString *name;
@property (copy ,nonatomic) NSString *sname;
@property (copy ,nonatomic) NSString *mark;
@property (copy ,nonatomic) NSString *host;
@property (nonatomic, copy) NSString *logo;


@end
