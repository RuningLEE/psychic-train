//
//  CouponModel.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"
#import "ShopStore.h"
#import "MineSettingModel.h"
#import "MineCouponDescModel.h"

@interface CouponModel : BaseModel
@property (strong, nonatomic) NSString *cashCodeId;
@property (strong, nonatomic) NSString *cashCouponCode;
@property (strong, nonatomic) NSString *userPhone;
@property (strong, nonatomic) NSString *cityId;
@property (strong, nonatomic) NSString *cateId;
@property (strong, nonatomic) ShopStore *store;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *statusName;
@property (strong, nonatomic) NSString *receiveTime;
@property (strong, nonatomic) NSString *checkTime;
@property (strong, nonatomic) NSString *validStart;
@property (strong, nonatomic) NSString *validEnd;
@property (strong, nonatomic) NSString *cashCouponId;
@property (strong, nonatomic) NSString *cashCouponName;
@property (strong, nonatomic) NSString *orderMoney;
@property (strong, nonatomic) NSString *fofExpo;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *meetAmount;
@property (strong, nonatomic) NSString *qrcodeImage;
@property (strong, nonatomic) MineSettingModel *setting;
@property (strong, nonatomic) MineCouponDescModel *desc;
@property (strong, nonatomic) NSString *parValue;
@end
