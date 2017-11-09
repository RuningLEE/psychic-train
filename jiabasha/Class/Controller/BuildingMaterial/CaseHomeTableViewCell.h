//
//  CaseHomeTableViewCell.h
//  jiabasha
//
//  Created by 金伟城 on 17/1/3.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnWatchProfiles;
@property (weak, nonatomic) IBOutlet UIView *viewProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBig;
@property (weak, nonatomic) IBOutlet UILabel *LabelPicNum;
@property (weak, nonatomic) IBOutlet UILabel *labelIntroduction; // 简介
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewIntroductionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelPicNumWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelNameWidth;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewJianTou;

- (void)loadCell:(NSDictionary *)exampleDetail;
@end
