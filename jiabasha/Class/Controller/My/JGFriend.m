//
//  JGFriend.m
//  QQ列表
//
//  Created by 郭军 on 16/8/14.
//  Copyright © 2016年 JUN. All rights reserved.
//

#import "JGFriend.h"

@implementation JGFriend

+ (instancetype)friendWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
