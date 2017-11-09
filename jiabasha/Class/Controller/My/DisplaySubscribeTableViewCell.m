//
//  DisplaySubscribeTableViewCell.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "DisplaySubscribeTableViewCell.h"

@implementation DisplaySubscribeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageviewCover.contentMode = UIViewContentModeScaleAspectFill;
    _imageviewCover.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
