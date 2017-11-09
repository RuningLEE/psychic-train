//
//  MyNaviControllerViewController.m
//  aibili
//
//  Created by zhangzt on 16/7/8.
//  Copyright © 2016年 hangzhouds. All rights reserved.
//

#import "CasePictureShowViewController.h"
#import "MyNaviControllerViewController.h"
#import "SystemNoticeDetailViewController.h"
#import "SystemNotifyViewController.h"
#import "ScanViewController.h"
#import "MessageViewController.h"

@interface MyNaviControllerViewController ()<UIGestureRecognizerDelegate>

@end

@implementation MyNaviControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 添加右滑手势
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
        [self addSwipeRecognizer];
}

// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    
    if ([self.topViewController isKindOfClass:[CasePictureShowViewController class]]) {
        return NO;
    }
    
    if ([self.topViewController isKindOfClass:[SystemNotifyViewController class]]) {
        return NO;
    }
    
    if ([self.topViewController isKindOfClass:[ScanViewController class]]) {
        return NO;
    }
    
    if ([self.topViewController isKindOfClass:[SystemNotifyViewController class]]) {
        return NO;
    }
    
    
    if ([self.topViewController isKindOfClass:[MessageViewController class]]) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 添加右滑手势
- (void)addSwipeRecognizer
{
    // 初始化手势并添加执行方法
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(return)];
    
    // 手势方向
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    // 响应的手指数
    swipeRecognizer.numberOfTouchesRequired = 1;
    
    // 添加手势
    [[self view] addGestureRecognizer:swipeRecognizer];
}

#pragma mark 返回上一级
- (void)return
{
    // 最低控制器无需返回
    if (self.viewControllers.count <= 1) return;
    
    // pop返回上一级
    [self popToRootViewControllerAnimated:YES];
}

//若在控制器之间跳转时需要做一些事情，可在自定义的控制器里添加下面两个方法

#pragma mark push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark pop方法
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    
    return [super popViewControllerAnimated:animated];
}


@end
