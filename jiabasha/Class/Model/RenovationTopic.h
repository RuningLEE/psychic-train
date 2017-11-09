//
//  RenovationTopic.h
//  jiabasha
//
//  Created by 金伟城 on 17/1/20.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"
/*
 返回:
 {"err": "ok",
 "data":[
 {
 "city_id":100010,
 "topic_pic_url":"http://3.tthunbohui.cn/n/00402VMG00bx1FMFD0E01A8.jpg",
 "topic_url":"http://bj.jiehun.com.cn",
 "product":[
 {
 "product_id":91590,
 "product_name":"热销套系",
 "img_url":"http://3.hapn.cc/n/008025CW008h1qzIkNb0e48-c346x346-1f6fa7.jpg"
 },{
 "product_id":91590,
 "product_name":"热销套系",
 "img_url":"http://3.hapn.cc/n/008025CW008h1qzIkNb0e48-c346x346-1f6fa7.jpg"
 }
 ]
 },{
 "city_id":100010,
 "topic_pic_url":"http://3.tthunbohui.cn/n/00402VMG00bx1FMFD0E01A8.jpg",
 "topic_url":"http://bj.jiehun.com.cn",
 "product":[]
 }
 ]
 }
 
*/

@interface RenovationTopic : BaseModel
@property (copy ,nonatomic) NSString *cityId;
@property (copy ,nonatomic) NSString *topicPicUrl;
@property (copy ,nonatomic) NSString *topicUrl;  // 商品 名称
@property (copy ,nonatomic) NSArray *product;

@end
