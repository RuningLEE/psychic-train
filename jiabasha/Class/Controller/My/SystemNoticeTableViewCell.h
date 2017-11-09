//
//  SystemNoticeTableViewCell.h
//  jiabasha
//
//  Created by jayhao on 2016/12/31.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemNotice.h"
#import "Letter.h"

@interface SystemNoticeTableViewCell : UITableViewCell
- (instancetype)initWithTableView:(UITableView *) tableView;
@property (strong, nonatomic) SystemNotice *systemModel;
@property (strong, nonatomic) Letter *letterModel;
@end
