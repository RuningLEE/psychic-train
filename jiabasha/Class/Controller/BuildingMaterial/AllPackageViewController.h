//
//  AllPackageViewController.h
//  jiabasha
//
//  Created by 金伟城 on 16/12/30.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllPackageViewController : UIViewController
@property (copy, nonatomic) NSString *storeName;
@property (copy, nonatomic) NSString *storeId;

@property (copy, nonatomic) NSString *isShop;
@property (strong, nonatomic) NSString *storeCategory;
@property (strong, nonatomic) NSMutableArray *storeCategoryArr;

@end
