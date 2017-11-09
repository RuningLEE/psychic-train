//
//  JGFriend.h
//  QQ列表
//
//  Created by 郭军 on 16/8/14.
//  Copyright © 2016年 JUN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGFriend : NSObject

/** 名字  */
@property (nonatomic, copy) NSString *name;
///** 图像  */
//@property (nonatomic, copy) NSString *icon;
///** 个性签名  */
//@property (nonatomic, copy) NSString *intro;
///** 会员 */
//@property (nonatomic, assign, getter = isVip) BOOL vip;

+ (instancetype)friendWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
