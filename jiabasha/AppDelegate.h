//
//  AppDelegate.h
//  jiabasha
//
//  Created by Jianyong Duan on 2016/12/26.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZMainTabController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *userid;

// tabbarView
@property (strong, nonatomic) JZMainTabController *MyTabBarController;

//新浪微博
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

//引导图
- (void)guideViewBeginClick;

//开屏广告图
- (void)startAdViewBeginClick:(NSString *)urlstring;

//全部案例跳转
@property (nonatomic, copy) NSString *allExample;

- (UINavigationController *)getNavigationController;

@end

