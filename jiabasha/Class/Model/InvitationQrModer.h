//
//  InvitationQrModer.h
//  jiabasha
//
//  Created by zhangzt on 2017/2/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface InvitationQrModer : BaseModel
@property (strong, nonatomic) NSString *uname;
@property (strong, nonatomic) NSString *userLevel;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *doorNumber;
@property (strong, nonatomic) NSString *enterStatus;
@property (strong, nonatomic) NSString *enterTips;
@property (strong, nonatomic) NSString *qrcodeTicketStr;
@end
