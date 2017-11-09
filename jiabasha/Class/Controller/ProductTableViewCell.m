//
//  ProductTableViewCell.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ProductTableViewCell.h"
#import "UIColor-Expanded.h"

@implementation ProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //描边
    self.controlPro.layer.borderWidth = .5;
    self.controlPro.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    self.controlPro1.layer.borderWidth = .5;
    self.controlPro1.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getHeightForDevice:(NSArray *)array {
    
    CGFloat width = (kScreenWidth - 25) / 2;
    
    CGFloat _height = 0;
    for (NSString *name in array) {
        _height = MAX([name getSizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(width - 10, 60)].height, _height);
    }
    
    if (_height > 20) {
        return width + 77 + 16;
    } else {
        return width + 77;
    }
}

@end
