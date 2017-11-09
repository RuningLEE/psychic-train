//
//  SettingTableViewCell.h
//  jiabasha
//
//  Created by zhangzt on 2016/12/30.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UISwitch *switchRight;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewArrow;

@end
