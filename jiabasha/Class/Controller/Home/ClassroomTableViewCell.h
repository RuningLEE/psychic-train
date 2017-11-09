//
//  ClassroomTableViewCell.h
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassroomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftToSuper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftToImage;


@end
