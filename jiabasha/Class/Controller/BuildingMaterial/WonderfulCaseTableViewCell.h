//
//  WonderfulCaseTableViewCell.h
//  jiabasha
//
//  Created by 金伟城 on 16/12/28.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BuildingExample;

@interface WonderfulCaseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewCheckAllCase;
@property (weak, nonatomic) IBOutlet UIView *viewTopLine;
@property (weak, nonatomic) IBOutlet UIButton *btnAllWatch;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelIntroduce; // 简介
@property (weak, nonatomic) IBOutlet UILabel *labelCompany;// 公司标签
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelSmallNameWidth;

- (void)loadData:(BuildingExample *)exampleData;
@end
