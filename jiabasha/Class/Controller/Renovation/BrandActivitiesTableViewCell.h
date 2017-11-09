//
//  BrandActivitiesTableViewCell.h
//  jiabasha
//
//  Created by 金伟城 on 17/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandActivitiesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UIView *viewHeadTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeadHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewGrayHeigth;

+ (CGFloat)getHeightForDevice:(BOOL)isHead isLast:(BOOL)islast;

@end
