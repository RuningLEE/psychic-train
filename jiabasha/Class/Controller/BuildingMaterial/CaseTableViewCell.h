//
//  CaseTableViewCell.h
//  jiabasha
//
//  Created by 金伟城 on 16/12/27.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BuildingExample;

@interface CaseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewTopLine;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBig;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSmall;
@property (weak, nonatomic) IBOutlet UILabel *labelSmallName;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelSmallNameWidth;


- (void)loadData:(BuildingExample *)exampleData;
@end
