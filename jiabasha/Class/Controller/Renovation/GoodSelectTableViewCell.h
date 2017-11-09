//
//  GoodSelectTableViewCell.h
//  jiabasha
//
//  Created by 金伟城 on 17/1/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodSelectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTopTitle;

@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeaderHeight;
@property (weak, nonatomic) IBOutlet UIView *viewRed;

@property (weak, nonatomic) IBOutlet UILabel *viewRedName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBig;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSmall1;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSmall2;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSmall3;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle1;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle2;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle3;

@property (weak, nonatomic) IBOutlet UILabel *labelPrice1;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice2;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice3;

@property (weak, nonatomic) IBOutlet UIButton *btnJump1;
@property (weak, nonatomic) IBOutlet UIButton *btnJump2;
@property (weak, nonatomic) IBOutlet UIButton *btnJump3;

+ (CGFloat)getHeightForDevice:(BOOL)isLast;

@end
