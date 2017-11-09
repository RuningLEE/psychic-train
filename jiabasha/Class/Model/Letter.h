//
//  Letter.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/11.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"
#import "MessageUser.h"

@interface Letter : BaseModel
@property (strong, nonatomic) MessageUser *fromUser;
@property (strong, nonatomic) NSString *letterId;
@property (strong, nonatomic) NSString *rrContent;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *isread;
@property (strong, nonatomic) NSString *sendTime;
@property (strong, nonatomic) NSString *count;
@property (strong, nonatomic) NSString *unreadCnt;
@property (strong, nonatomic) MessageUser *toUser;
@end
