//
//  EvlauateOrderViewController.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/6.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface EvlauateOrderViewController : UIViewController
@property (strong, nonatomic) OrderModel *orderModel;
@property(nonatomic,strong)NSString *type;//判断是修改点评还是点评
@property(nonatomic,strong)NSString *remarkID;
@end
