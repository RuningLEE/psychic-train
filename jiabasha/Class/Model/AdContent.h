//
//  AdContent.h
//  jiabasha
//
//  Created by guok on 17/1/16.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface AdContent : BaseModel

@property (copy ,nonatomic) NSString *adLocationName;
@property (copy ,nonatomic) NSString *adLocationEname;
@property (copy ,nonatomic) NSString *contentName;
@property (copy ,nonatomic) NSString *contentPicUrl;
@property (copy ,nonatomic) NSString *contentUrl;

@end
