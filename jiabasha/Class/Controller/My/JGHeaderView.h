//
//  JGHeaderView.h
//  QQ列表
//
//  Created by 郭军 on 16/8/14.
//  Copyright © 2016年 JUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGFriendGroup, JGHeaderView;

@protocol JGHeaderViewDelegate <NSObject>
@optional
- (void)headerViewDidClickedNameView:(JGHeaderView *)headerView;

@end

@interface JGHeaderView : UITableViewHeaderFooterView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JGFriendGroup *group;

/** 代理 */
@property (nonatomic, weak) id<JGHeaderViewDelegate> delegate;
@property (nonatomic, strong) UIButton *nameView;
@end
