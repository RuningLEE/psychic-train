//
//  BrandSpecialTableViewCell.h
//  jiabasha
//
//  Created by 金伟城 on 17/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandSpecialTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewRed1;
@property (weak, nonatomic) IBOutlet UIView *viewRed2;
@property (weak, nonatomic) IBOutlet UIView *viewRed3;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@property (weak, nonatomic) IBOutlet UILabel *labelPrice1;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice2;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice3;

@property (weak, nonatomic) IBOutlet UILabel *labelName1;
@property (weak, nonatomic) IBOutlet UILabel *labelName2;
@property (weak, nonatomic) IBOutlet UILabel *labelName3;

@property (weak, nonatomic) IBOutlet UILabel *labelNum1;
@property (weak, nonatomic) IBOutlet UILabel *labelNum2;
@property (weak, nonatomic) IBOutlet UILabel *labelNum3;


+ (CGFloat)getHeightForDevice;

@end
