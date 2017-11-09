//
//  StoreTableViewCell.h
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgViewLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCert;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewReturn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftForReturn;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewCard;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftForCard;

@property (weak, nonatomic) IBOutlet UILabel *labelOrderInfo;

@end
