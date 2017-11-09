//
//  CompanyCommentCell.h
//  jiabasha
//
//  Created by 金伟城 on 16/12/28.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StoreComment;

@interface CompanyCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewTopLine;
@property (weak, nonatomic) IBOutlet UILabel *labelUser;  // 用户
@property (weak, nonatomic) IBOutlet UILabel *labelSpendPrice; // 花费
@property (weak, nonatomic) IBOutlet UILabel *labelComment;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet UIView *viewTotalImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTotalImageHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

- (void)loadData:(StoreComment *)storeComment;

@end
