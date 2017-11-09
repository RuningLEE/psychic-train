//
//  PixelLineView.m
//  jiabasha
//
//  Created by Jianyong Duan on 2016/12/27.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "PixelLineView.h"

@implementation PixelLineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];

    for (NSLayoutConstraint *item in self.constraints) {
            
        if (item.firstItem ==  self && (item.firstAttribute == NSLayoutAttributeHeight || item.firstAttribute == NSLayoutAttributeWidth)) {
            
            if (item.constant == 1.0f) {
                item.constant = 1.0 / [UIScreen mainScreen].scale;
            }
            break;
        }
    }
}

@end
