//
//  EditFitmentViewController.h
//  jiabasha
//
//  Created by zhangzt on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineFitmentModel.h"

@interface EditFitmentViewController : UIViewController
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *demandId;
@property (strong, nonatomic) MineFitmentModel *fitMentModel;
@end
