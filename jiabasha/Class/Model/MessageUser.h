//
//  MessageUser.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/11.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface MessageUser : BaseModel
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *uname;
@property (strong, nonatomic) NSString *faceUrl;
@property (strong, nonatomic) NSString *faceId;
@end
