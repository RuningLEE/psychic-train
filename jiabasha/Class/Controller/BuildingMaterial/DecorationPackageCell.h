//
//  DecorationPackageCell.h
//  jiabasha
//
//  Created by 金伟城 on 16/12/28.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecorationPackageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *viewMember;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelRedName;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle; // 商品名称
@property (weak, nonatomic) IBOutlet UILabel *labelOriginalPrice; // 原价
@property (weak, nonatomic) IBOutlet UILabel *labelPresentPrice; // 现价
@property (weak, nonatomic) IBOutlet UILabel *labelNumPeopleJion;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewOrigunalPriceWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelPresentWidth;


@end
