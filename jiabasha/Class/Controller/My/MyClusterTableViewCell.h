//
//  MyClusterTableViewCell.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClusterModel.h"

@interface MyClusterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageviewCover;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPeopleNum;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelProcess;
@property (weak, nonatomic) IBOutlet UIButton *buttonJoin;
@property (strong, nonatomic) YYLabel *labelDelete;
@property (strong, nonatomic) MyClusterModel *clusterModel;
@property (weak, nonatomic) IBOutlet UIImageView *markIcon;
@end
