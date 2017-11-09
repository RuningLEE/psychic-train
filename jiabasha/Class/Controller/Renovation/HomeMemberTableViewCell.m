//
//  HomeMemberTableViewCell.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "HomeMemberTableViewCell.h"

@implementation HomeMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getHeightForDevice {
    return ((kScreenWidth / 5 ) * 110 / 75) * 2 + 46  + 10 ;
}

- (void)loadData{
    
}

@end
