//
//  CouponListTableViewCell.h
//  jiabasha
//
//  Created by guok on 17/1/16.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgViewLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelNum;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;

@end
