//
//  CompanyAllCommentViewController.h
//  jiabasha
//
//  Created by 金伟城 on 17/1/3.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StoreComment;

@interface CompanyAllCommentViewController : UIViewController

@property (strong, nonatomic) NSString *showType;
@property (strong, nonatomic) StoreComment * storeComment;
@property (strong, nonatomic) NSString *storeId;
@end
