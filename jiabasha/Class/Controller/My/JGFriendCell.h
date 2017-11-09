//
//  JGFriendCell.h
//  QQ列表
//
//  Created by 郭军 on 16/8/14.
//  Copyright © 2016年 JUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGFriend;

@interface JGFriendCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

// friend是C++的关键字,不能用friend作为属性名
/** 模型  */
@property (nonatomic, strong)JGFriend *friendData;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UITextField *MtextField;
@property(nonatomic,strong)UIButton *clearButton;
@end
