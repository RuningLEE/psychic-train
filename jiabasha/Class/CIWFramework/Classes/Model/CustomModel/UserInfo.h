//
//  UserInfo.h
//  weddingBusiness
//
//  Created by GarrettGao on 15/1/9.
//  Copyright (c) 2015年 HunBoHui. All rights reserved.
//

#import "BaseModel.h"
#import "User.h"

@interface UserInfo : BaseModel

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *tokenTime;
@property (nonatomic, strong) User *user;//用户信息



@property (nonatomic, assign) BOOL isLoginOut;


/**是否绑定推送用户 或取消绑定推送用户*/
- (void)bindPushUserWithIsBand:(BOOL)isBand withUserId:(NSString *)userId;

@end
