//
//  JGFriendGroup.h
//  QQ列表
//
//  Created by 郭军 on 16/8/14.
//  Copyright © 2016年 JUN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGFriendGroup : NSObject

/** 组名称  */
@property (nonatomic, copy) NSString *name;
/** 数组中装的都是JGFriend模型  */
@property (nonatomic, strong)NSArray *friends;



/** 标识这组是否需要展开,  YES : 展开 ,  NO : 关闭 */
@property (nonatomic, assign, getter = isOpend) BOOL opend;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)groupWithDict:(NSDictionary *)dict;

@end
