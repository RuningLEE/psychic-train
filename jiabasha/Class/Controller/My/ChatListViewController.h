//
//  ChatListViewController.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/11.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageUser.h"

@interface ChatListViewController : UIViewController
@property (strong, nonatomic) NSString *toId;
@property (strong, nonatomic) MessageUser *toUser;
@end
