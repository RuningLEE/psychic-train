//
//  MyClusterModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "MyClusterModel.h"

@implementation MyClusterModel

/*
 "product_id": 80372, 产品id
 "cate_id": 1104,    类目id
 "city_id": 110900,  城市id
 "store_id": 59866,  店铺id
 "product_name": "枫树林高端婚礼甜品台：棒棒蛋糕",  商品名称
 "product_pic_ids": "-6215374168690266275,6024438086016734157,8361517269928915321",  图片id
 "product_pic_url": "http://3.tthunbohui.cn/c/621/537/62153741686902662750-200X200.jpg", 图片地址
 "price": 18,    市场价
 "mall_price": 1,    商城价
 "tuan_price": 100,  当前价
 "tuan_max": 1,  拼团成功人数
 "tuan_count": 1 拼团参与人数
 "tuan_status": 3    拼团状态 0:拼团失败 1:拼团进行中 2:拼团完结 3:拼团成功
 */

- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"product_id",                   @"productId",
            @"cate_id",                      @"cateId",
            @"city_id",                      @"cityId",
            @"store_id",                     @"storeId",
            @"product_name",                 @"productName",
            @"product_pic_ids",              @"productPicIds",
            @"product_pic_url",              @"productPicUrl",
            @"price",                        @"price",
            @"mall_price",                   @"mallPrice",
            @"tuan_price",                   @"tuanPrice",
            @"tuan_max",                     @"tuanMax",
            @"tuan_count",                   @"tuanCount",
            @"tuan_status",                  @"tuanStatus",
            nil];
}

@end
