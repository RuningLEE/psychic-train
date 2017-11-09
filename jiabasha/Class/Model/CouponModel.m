//
//  CouponModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CouponModel.h"

@implementation CouponModel
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"cash_code_id",        @"cashCodeId",
            @"cash_coupon_code",    @"cashCouponCode",
            @"user_phone",          @"userPhone",
            @"city_id",             @"cityId",
            @"cate_id",             @"cateId",
            @"store",               @"store",
            @"status",              @"status",
            @"statusName",          @"statusName",
            @"receive_time",        @"receiveTime",
            @"check_time",          @"checkTime",
            @"valid_start",         @"validStart",
            @"valid_end",           @"validEnd",
            @"cash_coupon_id",      @"cashCouponId",
            @"cash_coupon_name",    @"cashCouponName",
            @"order_money",         @"orderMoney",
            @"order_id",            @"orderId",
            @"remark",              @"remark",
            @"qrcode_image",        @"qrcodeImage",
            @"fof_expo",            @"fofExpo",
            @"title",               @"title",
            @"summary",             @"summary",
            @"meet_amount",         @"meetAmount",
            @"setting",         @"setting",
            @"qrcode_image",         @"qrcodeImage",
            @"desc",         @"desc",
             @"par_value",         @"parValue",
            nil];
}
@end
