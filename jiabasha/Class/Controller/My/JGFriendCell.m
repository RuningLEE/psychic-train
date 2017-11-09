//
//  JGFriendCell.m
//  QQ列表
//
//  Created by 郭军 on 16/8/14.
//  Copyright © 2016年 JUN. All rights reserved.
//

#import "JGFriendCell.h"
#import "JGFriend.h"
@interface JGFriendCell ()<UITextFieldDelegate>

@end
@implementation JGFriendCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"friend";
    JGFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[JGFriendCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        [cell  CreatUI];
    }
    return cell;
}
-(void)CreatUI{
    _contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 8, 120, 24)];
    _contentLabel.textAlignment=NSTextAlignmentLeft;
    _contentLabel.textColor=[UIColor blackColor];
    _contentLabel.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_contentLabel];
    _MtextField=[[UITextField alloc]initWithFrame:CGRectMake(_contentLabel.frame.size.width+_contentLabel.frame.origin.x, 8,self.contentView.frame.size.width-_contentLabel.frame.size.width-_contentLabel.frame.origin.x, 24)];
    _MtextField.delegate=self;
    [self.contentView addSubview:_MtextField];
    _clearButton=[[UIButton alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-50, 10, 20, 20)];
    [_clearButton setImage:[UIImage imageNamed:@"delegate"] forState:UIControlStateNormal];
    [_clearButton addTarget:self action:@selector(ClearToal) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)ClearToal{
    _MtextField.text=@"";
}
- (void)setFriendData:(JGFriend *)friendData {
    
    _friendData = friendData;
    _contentLabel.text=_friendData.name;
//    self.imageView.image = [UIImage imageNamed:friendData.icon];
//    self.textLabel.text = friendData.name;
//    self.textLabel.textColor = friendData.isVip ? [UIColor redColor] : [UIColor blackColor];
//    self.detailTextLabel.text = friendData.intro;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
