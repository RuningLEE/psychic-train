//
//  CashCouponTableViewCell.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/6.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

@interface CashCouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewCover;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *labelType;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDeadline;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewMark;
@property (weak, nonatomic) IBOutlet UILabel *labelrmb;
- (void)initWithCouponModel:(CouponModel *)couponModel;
@end
