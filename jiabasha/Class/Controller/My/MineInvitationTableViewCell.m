//
//  MineInvitationTableViewCell.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "MineInvitationTableViewCell.h"
#import "Masonry.h"

@implementation MineInvitationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _yyLabelDesc = [[YYLabel alloc]init];
    _yyLabelDesc.numberOfLines = 0;
    _yyLabelDesc.font = [UIFont systemFontOfSize:12];
    _yyLabelDesc.textColor = RGB(153, 153, 153);
    [self.contentView insertSubview:_yyLabelDesc aboveSubview:_labelDesc];
    [_yyLabelDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(_labelDesc);
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
