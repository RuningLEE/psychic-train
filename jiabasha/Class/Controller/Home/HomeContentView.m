//
//  HomeContentView.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/3.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "HomeContentView.h"

@implementation HomeContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//标题
+ (HomeContentView *)instanceTitleView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"HomeContentView" owner:nil options:nil];
    return [views objectAtIndex:0];
}

//热门活动
+ (HomeContentView *)instanceActiveView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"HomeContentView" owner:nil options:nil];
    return [views objectAtIndex:1];
}

//家芭莎课堂
+ (HomeContentView *)instanceClassRoomView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"HomeContentView" owner:nil options:nil];
    return [views objectAtIndex:2];
}

//商品
+ (HomeContentView *)instanceProductView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"HomeContentView" owner:nil options:nil];
    return [views objectAtIndex:3];
}

@end
