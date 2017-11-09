//
//  JGFriendGroup.m
//  QQ列表
//
//  Created by 郭军 on 16/8/14.
//  Copyright © 2016年 JUN. All rights reserved.
//

#import "JGFriendGroup.h"
#import "JGFriend.h"

@implementation JGFriendGroup

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        //KVC模式 注入所有属性
        [self setValuesForKeysWithDictionary:dict];
        
        //特殊处理friend属性
        NSMutableArray *friendArrM = [NSMutableArray array];
        for (NSDictionary *dict in self.friends) {
            JGFriend *friend = [JGFriend friendWithDict:dict];
            [friendArrM addObject:friend];
        }
        self.friends = friendArrM;
    }
    return self;
}
+ (instancetype)groupWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
}

@end
