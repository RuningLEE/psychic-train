//
//  HomeActivityTableViewCell.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "HomeActivityTableViewCell.h"

@implementation HomeActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getHeightForDevice {
    return kScreenWidth * 260 / 750;
}

@end
