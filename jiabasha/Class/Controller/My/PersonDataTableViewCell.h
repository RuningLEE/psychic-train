//
//  PersonDataTableViewCell.h
//  jiabasha
//
//  Created by zhangzt on 2016/12/28.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonDataTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property (weak, nonatomic) IBOutlet UIImageView *imageviewRighticon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constantTrailing;

@property (weak, nonatomic) IBOutlet UITextField *textfiledSubtitle;

@end
