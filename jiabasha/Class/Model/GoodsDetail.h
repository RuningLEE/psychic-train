//
//  GoodsDetail.h
//  jiabasha
//
//  Created by 金伟城 on 17/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface GoodsDetail : BaseModel
@property (copy ,nonatomic) NSString *city_id;
@property (copy ,nonatomic) NSString *store_id;
@property (copy ,nonatomic) NSString *product_name;  // 商品 名称
@property (copy ,nonatomic) NSArray *imgs;
@property (copy ,nonatomic) NSString *mall_price;
@property (copy ,nonatomic) NSString *price;
@property (copy ,nonatomic) NSString *short_desc; // 我是简 要说明
@property (copy ,nonatomic) NSString *attr;
@property (copy ,nonatomic) NSString *store_info;
@property (copy ,nonatomic) NSArray *coupon;
@property (copy ,nonatomic) NSString *contents; // 商品详情
@property (copy ,nonatomic) NSString *guess;
@property (copy ,nonatomic) NSString *huiyuanjie;
@property (copy ,nonatomic) NSString *productId;
@property (copy ,nonatomic) NSString *productPicUrl;
@property (copy ,nonatomic) NSString *productPicId;
@property (copy ,nonatomic) NSDictionary *tuan;
@property (copy ,nonatomic) NSDictionary *tuanSetting;
@end
