//
//  CompanyTableViewCell.h
//  jiabasha
//
//  Created by 金伟城 on 16/12/27.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Store;

@interface CompanyTableViewCell : UITableViewCell
- (void)loadData:(Store *)StoreData;

@property (weak, nonatomic) IBOutlet UIButton *btnCaseOne;
@property (weak, nonatomic) IBOutlet UIButton *btnCaseTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnCaseThree;

@end
