//
//  GoodSelectTableViewCell.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GoodSelectTableViewCell.h"

@implementation GoodSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     _viewRed.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getHeightForDevice:(BOOL)isLast{
    if (isLast) {
        return 35 + (155*(kScreenWidth-20)/355)*2 ;
    }else{
        return 66 + (155*(kScreenWidth-20)/355)*2 ;
    }
  
}


@end
