//
//  SearchNearbyTableViewCell.h
//  jiabasha
//
//  Created by 金伟城 on 17/1/3.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchNearbyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewNumCase;
@property (weak, nonatomic) IBOutlet UILabel *labelnName;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelCaseNum;

@end