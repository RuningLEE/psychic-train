//
//  MyClusterModel.h
//  jiabasha
//
//  Created by zhangzt on 2017/2/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface MyClusterModel : BaseModel
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *cateId;
@property (strong, nonatomic) NSString *cityId;
@property (strong, nonatomic) NSString *storeId;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *productPicIds;
@property (strong, nonatomic) NSString *productPicUrl;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *mallPrice;
@property (strong, nonatomic) NSString *tuanPrice;
@property (strong, nonatomic) NSString *tuanMax;
@property (strong, nonatomic) NSString *tuanCount;
/**
 拼团状态 0:拼团失败 1:拼团进行中 2:拼团完结 3:拼团成功
 */
@property (strong, nonatomic) NSString *tuanStatus;
@end
