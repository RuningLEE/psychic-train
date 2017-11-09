//
//  Banner.h
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/4.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface Banner : BaseModel

@property (copy ,nonatomic) NSString *cityId;
@property (copy ,nonatomic) NSString *contentTile;
@property (copy ,nonatomic) NSString *contentUrl;
@property (copy ,nonatomic) NSString *contentPicUrl;

@end
