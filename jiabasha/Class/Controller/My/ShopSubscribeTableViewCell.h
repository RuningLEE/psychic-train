//
//  ShopSubscribeTableViewCell.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubscribeStore.h"

@interface ShopSubscribeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageviewCover;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSubtitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewRight;
- (void)initWithSubstoreModel:(SubscribeStore *)subscribeStore;
@end
