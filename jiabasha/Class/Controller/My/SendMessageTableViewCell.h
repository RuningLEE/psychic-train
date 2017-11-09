//
//  SendMessageTableViewCell.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/11.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionLetter.h"

@interface SendMessageTableViewCell : UITableViewCell
@property (strong, nonatomic) SessionLetter *letterModel;
@property (strong, nonatomic) User *user;
- (CGFloat)countCellHeightWithMessageDictionary:(NSDictionary *)messageDictionary;
@end
