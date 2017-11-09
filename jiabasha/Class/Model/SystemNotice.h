//
//  SystemNotice.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface SystemNotice : BaseModel
@property (strong, nonatomic) NSString *noticeId;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *isread;
@property (strong, nonatomic) NSString *sendTime;
@property (strong, nonatomic) NSString *iteType;
@property (strong, nonatomic) NSString *itmeId;
@property (strong, nonatomic) NSString *sendUid;
@property (strong, nonatomic) NSString *sendUname;
@end
