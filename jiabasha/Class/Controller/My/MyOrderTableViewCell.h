//
//  MyOrderTableViewCell.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/6.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface MyOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *BgView;
@property (weak, nonatomic) IBOutlet UILabel *labelOrderNum;
@property (weak, nonatomic) IBOutlet UILabel *labelState;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewCover;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelsubTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonEvaluate;
@property (strong, nonatomic) OrderModel *orderModel;
@property (weak, nonatomic) IBOutlet UIButton *fanXian;

@end
