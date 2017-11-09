//
//  ProductTableViewCell.h
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/10.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIControl *controlPro;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPic;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelOriginal;
@property (weak, nonatomic) IBOutlet UIView *viewMark;
@property (weak, nonatomic) IBOutlet UILabel *labelMark;

@property (weak, nonatomic) IBOutlet UIControl *controlPro1;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPic1;
@property (weak, nonatomic) IBOutlet UILabel *labelName1;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice1;
@property (weak, nonatomic) IBOutlet UILabel *labelOriginal1;
@property (weak, nonatomic) IBOutlet UIView *viewMark1;
@property (weak, nonatomic) IBOutlet UILabel *labelMark1;

+ (CGFloat)getHeightForDevice:(NSArray *)array;

@end
