//
//  HomeExampleTableViewCell.h
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeExampleTableViewCell : UITableViewCell

//head
@property (weak, nonatomic) IBOutlet UIView *viewHead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForHead;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIControl *controlEx;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPic;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelExName;
@property (weak, nonatomic) IBOutlet UILabel *labelStoreName;
@property (weak, nonatomic) IBOutlet UILabel *labelText;

//查看所有
@property (weak, nonatomic) IBOutlet UIControl *controlMore;
@property (weak, nonatomic) IBOutlet UILabel *labelMore;

+ (CGFloat)getHeightForRow:(NSUInteger)row Count:(NSUInteger)count;
+ (CGFloat)getNormalHeight;

@end
