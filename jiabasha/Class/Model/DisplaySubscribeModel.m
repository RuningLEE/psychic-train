//
//  DisplaySubscribeModel.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "DisplaySubscribeModel.h"

@implementation DisplaySubscribeModel
/*
 "reserve_id": "1096834", "store":{ "store_id": "60967", "store_name": "晒唐婚礼 定制", "logo": "" } "city_id": "110900", "cate_id": "1060", "reserve_status": "1", 0已取消 1待安排 2已安排 3已到店 4未赴 约 5商家已取消 "create_time": "2016-01-02 00:00:01", 预约时间 "appoint_time": "2016-01-02 00:00:01", 到店时间 "remarks": "", 备注 "cancel_time": "0", 取消预约时间 "reserve_type": "2", 1预约 到店 2预约到展会 "expo":{ "expo_id": "273", "city_id": "310900", "expo_name": "2016冬季中国婚博会", "start_time": "2017-01-03 12:01:0", "stop_time": "2017-01-23 12:00:00" } }
 */
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"reserve_id",       @"reserveId",
            @"store",            @"store",
            @"city_id",          @"cityId",
            @"cate_id",          @"cateId",
            @"reserve_status",   @"reserveStatus",
            @"create_time",      @"createTime",
            @"appoint_time",     @"appointTime",
            @"remarks",          @"remarks",
            @"cancel_time",      @"cancelTime",
            @"reserve_type",     @"reserveType",
            @"expo",             @"expo",
            nil];
}

@end
