//
//  ReceiveMessageTableViewCell.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/11.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageUser.h"
#import "SessionLetter.h"

@interface ReceiveMessageTableViewCell : UITableViewCell
@property (strong, nonatomic) SessionLetter *letterModel;
@property (strong, nonatomic) MessageUser *user;
- (CGFloat)countCellHeightWithMessageDictionary:(NSDictionary *)messageDictionary;
@end
