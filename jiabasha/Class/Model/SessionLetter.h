//
//  SessionLetter.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/11.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface SessionLetter : BaseModel
@property (strong, nonatomic) NSString *letterId;
@property (strong, nonatomic) NSString *toUid;
@property (strong, nonatomic) NSString *fromUid;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *isread;
@end
