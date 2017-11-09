//
//  MyClusterCollectionViewCell.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface MyClusterCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageviewCover;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelNum;
@property (strong, nonatomic) YYLabel *labelDelete;
@property (strong, nonatomic) Product *clusterProduct;
@property (weak, nonatomic) IBOutlet UIView *viewInsert;
@property (weak, nonatomic) IBOutlet UILabel *labelNumFront;
@property (weak, nonatomic) IBOutlet UILabel *labelNumAfter;
@end
