//
//  PersonDataHeadiconTableViewCell.m
//  jiabasha
//
//  Created by zhangzt on 2016/12/28.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "PersonDataHeadiconTableViewCell.h"

@implementation PersonDataHeadiconTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _ImageViewHead.layer.cornerRadius = 20;
    _ImageViewHead.layer.masksToBounds = YES;
    _ImageViewHead.clipsToBounds = YES;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
