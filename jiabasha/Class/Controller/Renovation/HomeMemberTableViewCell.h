//
//  HomeMemberTableViewCell.h
//  jiabasha
//
//  Created by 金伟城 on 17/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMemberTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UIImageView *imgView4;


@property (weak, nonatomic) IBOutlet UIImageView *imgView5;
@property (weak, nonatomic) IBOutlet UIImageView *imgView6;
@property (weak, nonatomic) IBOutlet UIImageView *imgView7;
@property (weak, nonatomic) IBOutlet UIImageView *imgView8;

+ (CGFloat)getHeightForDevice;

- (void)loadData;
@end
