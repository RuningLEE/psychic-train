//
//  BrandActivitiesTableViewCell.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BrandActivitiesTableViewCell.h"

@implementation BrandActivitiesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getHeightForDevice:(BOOL)isHead isLast:(BOOL)islast{
    float heigth;
    if (isHead) {
        heigth = 27 + 155*(kScreenWidth-20)/355 ;
    }else{
        heigth = 73 + 155*(kScreenWidth-20)/355;
    }
    if (islast) {
        heigth -= 10;
    }

    return heigth;
}


@end
