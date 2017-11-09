//
//  BrandSpecialTableViewCell.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BrandSpecialTableViewCell.h"

@implementation BrandSpecialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _viewRed1.layer.cornerRadius = 4;
    _viewRed2.layer.cornerRadius = 4;
    _viewRed3.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getHeightForDevice {
    return 107 + kScreenWidth *133/375;
}


@end
