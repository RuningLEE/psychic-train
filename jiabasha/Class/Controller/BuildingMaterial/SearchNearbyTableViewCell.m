//
//  SearchNearbyTableViewCell.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/3.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "SearchNearbyTableViewCell.h"

@implementation SearchNearbyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.viewNumCase.layer.cornerRadius = 3;
    self.viewNumCase.layer.borderWidth = 0.7;
    self.viewNumCase.layer.borderColor = RGB(232, 232, 232).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
