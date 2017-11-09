//
//  HomeBannerTableViewCell.h
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

//首页轮播图 + 导航入口
@interface HomeBannerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewBanner;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftForScrollView;

@property (weak, nonatomic) IBOutlet UIView *viewKnow;

//0-精选 1-攻略
+ (CGFloat)heightByType:(NSInteger)type;

@end
