//
//  MyClusterTableViewCell.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "MyClusterTableViewCell.h"
#import "Masonry.h"

@implementation MyClusterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setClusterModel:(MyClusterModel *)clusterModel
{
    _clusterModel = clusterModel;

    NSString *price = [NSString stringWithFormat:@"¥ %@",_clusterModel.price];
    NSMutableAttributedString *deleteStr = [[NSMutableAttributedString alloc]initWithString:price];
    YYTextDecoration *decoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle width:[NSNumber numberWithInt:1] color:[UIColor lightGrayColor]];
    [deleteStr setYy_textStrikethrough:decoration];
    [deleteStr setYy_color:[UIColor lightGrayColor]];
    [deleteStr setYy_font:[UIFont systemFontOfSize:13]];

    _labelDelete = [[YYLabel alloc]init];
    _labelDelete.attributedText = deleteStr;
    //布局labeldelete
    [self.contentView addSubview:_labelDelete];
    [_labelDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_labelPrice.mas_bottom).offset(-3);
        make.left.mas_equalTo(_labelPrice.mas_right).offset(6);
    }];
    _buttonJoin.layer.cornerRadius = 2;
    _buttonJoin.layer.masksToBounds = YES;

    [_imageviewCover sd_setImageWithURL:[NSURL URLWithString:_clusterModel.productPicUrl] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
    /*
      0:拼团失败 1:拼团进行中 2:拼团完结 3:拼团成功
     */
    if ([_clusterModel.tuanStatus isEqualToString:@"0"]) {
        self.markIcon.image = [UIImage imageNamed:@"我的拼团_拼团失败"];
    } else if ([_clusterModel.tuanStatus isEqualToString:@"1"]) {
        self.markIcon.image = [UIImage imageNamed:@"我的拼团_拼团进行中"];
    } else if ([_clusterModel.tuanStatus isEqualToString:@"2"]) {
        self.markIcon.image = [UIImage imageNamed:@"我的拼团_拼团完结"];
    } else if ([_clusterModel.tuanStatus isEqualToString:@"3"]) {
        self.markIcon.image = [UIImage imageNamed:@"我的拼团_拼团成功"];
    }
    _labelPeopleNum.text = _clusterModel.tuanMax;
    _labelPrice.text = _clusterModel.tuanPrice;
    _labelProcess.text = [NSString stringWithFormat:@"拼团进度：%@/%@", _clusterModel.tuanCount,_clusterModel.tuanMax];
   _labelProcess.text = [_labelProcess.text stringByReplacingOccurrencesOfString:@"(null)" withString:@"0"];
   
}

@end
