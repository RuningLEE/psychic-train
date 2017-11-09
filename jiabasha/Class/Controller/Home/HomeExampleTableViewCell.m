//
//  HomeExampleTableViewCell.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "HomeExampleTableViewCell.h"
#import "UIColor-Expanded.h"

@implementation HomeExampleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //描边
    self.imgViewLogo.layer.borderWidth = .5;
    self.imgViewLogo.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getHeightForDevice {
    return (kScreenWidth - 20) * 400 / 710 + 66;
}

+ (CGFloat)getHeightForRow:(NSUInteger)row Count:(NSUInteger)count {
    CGFloat height = (kScreenWidth - 20) * 400 / 710 + 66;
    if (count == 1) {
        return height + 100;
    } else if (row == 0) {
        //第一行加标题
        return 50 + height + 15;
    } else if (row == count - 1) {
        //最后一行加更多
        return height + 50;
    } else {
        return height + 15;
    }
}

+ (CGFloat)getNormalHeight {
    CGFloat height = (kScreenWidth - 20) * 400 / 710 + 66;
    return height + 15;
}

@end
