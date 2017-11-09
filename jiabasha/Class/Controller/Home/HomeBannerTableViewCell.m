//
//  HomeBannerTableViewCell.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "HomeBannerTableViewCell.h"

@implementation HomeBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//0-精选 1-攻略
+ (CGFloat)heightByType:(NSInteger)type {
    
    CGFloat height = kScreenWidth * 360 / 750;
    if (type == 0) {
        return height + 81;
    } else {
        return height + 88; //10 + 68 + 10
    }
}

@end
