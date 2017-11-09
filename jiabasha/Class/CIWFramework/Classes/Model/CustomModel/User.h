//
//  User.h
//  weddingBusiness
//
//  Created by GarrettGao on 15/1/9.
//  Copyright (c) 2015年 HunBoHui. All rights reserved.
//

#import "BaseModel.h"


@interface User : BaseModel

//@property (nonatomic, strong) NSString *userId;
//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *allScore;
//@property (nonatomic, strong) NSString *bwcScore;
//@property (nonatomic, strong) NSString *ptYcScore;
//@property (nonatomic, strong) NSString *bwcYcScore;
//@property (nonatomic, strong) NSDictionary *headImages;
////@property (nonatomic, strong) NSArray *myBgImages;
//@property (nonatomic, readonly) NSString *headSmall;
//@property (nonatomic, readonly) NSString *headBig;
//@property (nonatomic, readonly) NSString *headOrigin;
////@property (nonatomic, readonly) NSString *myBgImageSmall;
////@property (nonatomic, readonly) NSString *myBgImageBig;
////@property (nonatomic, readonly) NSString *myBgImageOrigin;
//@property (nonatomic, strong) NSString *bindStatus;
//@property (nonatomic, strong) NSString *phone;
//@property (nonatomic, strong) NSString *source;
//
//@property (nonatomic, strong) NSString *uLevel;
//@property (nonatomic, strong) NSString *qrcodeImg;
//@property (nonatomic, strong) NSString *uLevelUrl;
//@property (nonatomic, strong) NSString *liveCity;
//@property (nonatomic, strong) NSString *gender;
//@property (nonatomic, strong) NSString *qq;

@property (strong, nonatomic) NSString *autoLoginKey;
@property (strong, nonatomic) NSString *bindStatus;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *lastLoginIp;
@property (strong, nonatomic) NSString *qq;
@property (strong, nonatomic) NSString *realName;
@property (strong, nonatomic) NSString *reason;
@property (strong, nonatomic) NSString *regip;
@property (strong, nonatomic) NSString *source;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *userExtra;
/**
 *用户uid
 */
@property (strong, nonatomic) NSString *uid;
/**
 *用户昵称
 */
@property (strong, nonatomic) NSString *uname;
/**
 *用户等级
 */
@property (strong, nonatomic) NSString *userLevel;
/**
 *"2017-01-04 09:31:54", 最后一次登录时间
 */
@property (strong, nonatomic) NSString *lastLoginTime;
/**
 *
 */
@property (strong, nonatomic) NSString *score;
/**
 *二维码
 */
@property (strong, nonatomic) NSString *qrcodeImg;
/**
 *邮箱地址
 */
@property (strong, nonatomic) NSString *email;
/**
 *电话
 */
@property (strong, nonatomic) NSString *phone;
/**
 *城市id
 */
@property (strong, nonatomic) NSString *cityId;
/**
 *用户头像id
 */
@property (strong, nonatomic) NSString *faceId;
/**
 *用户头像url
 */
@property (strong, nonatomic) NSString *faceUrl;
/**
 未读消息数量
 */
@property (strong, nonatomic) NSString *unreadMessageCnt;
/**
 签到礼文案
 */
@property (strong, nonatomic) NSString *signInText;
/**
 签到礼链接
 */
@property (strong, nonatomic) NSString *signInUrl;
/**
 是否在会员节时段内
 */
@property (strong, nonatomic) NSString *huiyuanjieOrder;
@end
