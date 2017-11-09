//
//  FreeFunctionViewController.h
//  jiabasha
//
//  Created by 金伟城 on 16/12/30.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeFunctionViewController : UIViewController
@property (strong, nonatomic) NSString * freeType; // 0:免费验房  1:免费量房 2:免费设计 3:免费预约
@property (strong, nonatomic) NSString * appiontType;
@property (strong, nonatomic) NSString * companyName;
@property (strong, nonatomic) NSString * storeId;
@end
