//
//  PlaceholderColorTextField.m
//  jiabasha
//
//  Created by Jianyong Duan on 2016/12/27.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "PlaceholderColorTextField.h"
#import "UIColor-Expanded.h"

@implementation PlaceholderColorTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (self.placeholder) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#cccccc"]}];
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 2, 1);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 2, 1);
}

@end
