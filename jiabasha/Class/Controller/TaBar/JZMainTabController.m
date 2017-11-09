//
//  UKMainTabController.m
//
//
//  Created by jinwc on 16/8/1.
//  Copyright (c) 2016年 Netease. All rights reserved.
//


#import "AppDelegate.h"
#import "JZMainTabController.h"
#import "MyViewController.h"
#import "BuildingMaterialViewController.h"
#import "HomeExpoViewController.h"
#import "RenovationViewController.h"
#import "HomeViewController.h"
#import "MyNaviControllerViewController.h"
#import "AppInstallRequest.h"
#import  "XWLocationManager.h"

#import "VisionAlterViewRequest.h"
#import "VisionAlterView.h"
@interface JZMainTabController ()<UIActionSheetDelegate>

@property (strong, nonatomic) UIControl *controlHomeItem;
@property (strong, nonatomic) UIControl *controlBuildingMaterialItem;
@property (strong, nonatomic) UIControl *controlHomeExpoItem;
@property (strong, nonatomic) UIControl *controlRenovationItem;
@property (strong, nonatomic) UIControl *controlMyItem;
@property (strong, nonatomic) UIControl *selectItem;
@property(nonatomic,strong) VisionAlterView *activityView;
@end

@implementation JZMainTabController
-(void)viewWillAppear:(BOOL)animated{
    [self GetAcivityAlterView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLOcation];
    // 添加子控制器
    HomeViewController *HomeVC = [[HomeViewController alloc] init];
    BuildingMaterialViewController *BuildingMaterialVC = [[BuildingMaterialViewController alloc] init];
    HomeExpoViewController *HomeExpoVC = [[HomeExpoViewController alloc] init];
    RenovationViewController *RenovationVC = [[RenovationViewController alloc] init];
    MyViewController *MyVC = [[MyViewController alloc] init];
    NSArray *controllerArray = [[NSArray alloc] initWithObjects:HomeVC,BuildingMaterialVC,HomeExpoVC,RenovationVC,MyVC,nil];
    self.viewControllers = controllerArray;
    
    // 添加tabar显示的内容
    [self addMyTabBar];
    
    // 选择首页
    [self controlHomeClick];
    
    //新手指南
    if (![[USER_DEFAULT objectForKey:@"NewbieGuide"] boolValue])
    {
        [USER_DEFAULT setObject:[NSNumber numberWithBool:YES] forKey:@"NewbieGuide"];
        [USER_DEFAULT synchronize];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [button setBackgroundImage:[UIImage imageNamed:@"新手指南1"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(newbieGuideClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1;
        [self.view addSubview:button];
    }

    // 注册app
    [AppInstallRequest installRequest];
}
#pragma mark //版本弹框

-(void)GetAcivityAlterView{
    NSDictionary *param;
    
    param = [NSDictionary dictionaryWithObjectsAndKeys:DATA_ENV.userInfo.user.cityId,@"city_id", nil];
    [VisionAlterViewRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[VisionAlterViewRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            NSLog(@"******==%@",APP_VERSION);
            if([request.resultDic[@"data"][@"popup_version"] isEqualToString:APP_VERSION]){
                
            }else{
                if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
                    [self showAlterView:request.resultDic[@"data"][@"popup_content"]];
                    
                }else{
                    NSLog(@"bool");
                }

           
            
            }
            
        } else {
            
            //[self.view makeToast:@"失败" duration:1 position:CSToastPositionCenter];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
        [self.view makeToast:@"提交失败" duration:1 position:CSToastPositionCenter];
    }];
    
}
#pragma mark 弹出活动框
-(void)showAlterView:(NSMutableDictionary *)dic{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    if (_activityView == nil) {
        _activityView = [[VisionAlterView alloc]init];
        
        _activityView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        __weak typeof(self)WeakSelf = self;
        [_activityView setClickBlock:^(Vlterclicktype type) {
            switch (type) {
                case Vclick_blank:
                    [WeakSelf.activityView dismiss];
                    WeakSelf.activityView = nil;
                    break;
                case Vclick_dismiss:
                    [WeakSelf.activityView dismiss];
                    WeakSelf.activityView = nil;
                    break;
                default:
                    break;
            }
        }];
        
        [self.view addSubview:_activityView];
    }
    _activityView.QRimage = dic;
    [_activityView show];
    
}

- (void)newbieGuideClicked:(UIButton *)button {
    NSInteger tag = button.tag + 1;
    if (tag <= 3) {
        button.tag = tag;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"新手指南%ld", tag]] forState:UIControlStateNormal];
    } else {
        [button removeFromSuperview];
    }
}


-(void)viewWillLayoutSubviews
{
    self.view.frame = [UIScreen mainScreen].bounds;
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 选择首页
- (void)controlHomeClick
{
    if ([self.selectItem isEqual:self.controlHomeItem]) return;
    self.selectedIndex = 0;
    [self selectItem:self.controlHomeItem];
}

// 选择装修公司
- (void)controlBuildingMaterialClick
{
    if ([self.selectItem isEqual:self.controlBuildingMaterialItem]) return;
    self.selectedIndex = 1;
    [self selectItem:self.controlBuildingMaterialItem];
}

// 选择家博会
- (void)controlHomeExpoClick
{
    if ([self.selectItem isEqual:self.controlHomeExpoItem]) return;
    self.selectedIndex = 2;
    [self selectItem:self.controlHomeExpoItem];
}

// 选择建材家电
- (void)controlRenovationClick
{
    if ([self.selectItem isEqual:self.controlRenovationItem]) return;
    self.selectedIndex = 3;
    [self selectItem:self.controlRenovationItem];
    
}

// 选择我的
- (void)controlMyClick
{
    if ([self.selectItem isEqual:self.controlMyItem]) return;
    self.selectedIndex = 4;
    [self selectItem:self.controlMyItem];
    
}

// 选择后状态修改
- (void)selectItem:(UIControl *)targetItem
{

    UILabel *labelOrigin = (UILabel *)[self.selectItem viewWithTag:101];
    if ([self.selectItem isEqual:self.controlHomeItem]) {
        [labelOrigin setTextColor:RGB(153, 153, 153)];
    } else if ([self.selectItem isEqual:self.controlBuildingMaterialItem]) {
        [labelOrigin setTextColor:RGB(153, 153, 153)];
    } else if ([self.selectItem isEqual:self.controlHomeExpoItem]) {
        [labelOrigin setTextColor:RGB(153, 153, 153)];
    }else if ([self.selectItem isEqual:self.controlRenovationItem]){
        [labelOrigin setTextColor:RGB(153, 153, 153)];
    }else if ([self.selectItem isEqual:self.controlMyItem]){
        [labelOrigin setTextColor:RGB(153, 153, 153)];
    }

    UILabel *labelTarget = (UILabel *)[targetItem viewWithTag:101];
    if ([targetItem isEqual:self.controlHomeItem]) {
        [labelTarget setTextColor:RGB(96, 25, 134)];
    } else if ([targetItem isEqual:self.controlBuildingMaterialItem]) {
        [labelTarget setTextColor:RGB(96, 25, 134)];
    } else  if ([targetItem isEqual:self.controlHomeExpoItem]){
        [labelTarget setTextColor:RGB(96, 25, 134)];
    }else if ([targetItem isEqual:self.controlRenovationItem]){
        [labelTarget setTextColor:RGB(96, 25, 134)];
    }else if ([targetItem isEqual:self.controlMyItem]){
        [labelTarget setTextColor:RGB(96, 25, 134)];
    }
    
    UIImageView *imgViewOriginIcon = (UIImageView *)[self.selectItem viewWithTag:100];
    if ([self.selectItem isEqual:self.controlHomeItem]) {
        [imgViewOriginIcon setImage:[UIImage imageNamed:@"首页-未选中"]];
    } else if ([self.selectItem isEqual:self.controlBuildingMaterialItem]) {
        [imgViewOriginIcon setImage:[UIImage imageNamed:@"装修公司-未选中"]];
    } else if ([self.selectItem isEqual:self.controlHomeExpoItem]) {
        [imgViewOriginIcon setImage:[UIImage imageNamed:@"家博会-未选中"]];
    }else if ([self.selectItem isEqual:self.controlRenovationItem]){
        [imgViewOriginIcon setImage:[UIImage imageNamed:@"建材家电-未选中"]];
    }else if ([self.selectItem isEqual:self.controlMyItem]){
        [imgViewOriginIcon setImage:[UIImage imageNamed:@"我的-未选中"]];
    }
    
    UIImageView *imgViewTargetIcon = (UIImageView *)[targetItem viewWithTag:100];
    if ([targetItem isEqual:self.controlHomeItem]) {
        [imgViewTargetIcon setImage:[UIImage imageNamed:@"首页-选中"]];
    } else if ([targetItem isEqual:self.controlBuildingMaterialItem]) {
        [imgViewTargetIcon setImage:[UIImage imageNamed:@"装修公司-选中"]];
    } else  if ([targetItem isEqual:self.controlHomeExpoItem]){
        [imgViewTargetIcon setImage:[UIImage imageNamed:@"家博会-选中"]];
    }else if ([targetItem isEqual:self.controlRenovationItem]){
        [imgViewTargetIcon setImage:[UIImage imageNamed:@"建材家电-选中"]];
    }else if ([targetItem isEqual:self.controlMyItem]){
        [imgViewTargetIcon setImage:[UIImage imageNamed:@"我的-选中"]];
    }
    
    self.selectItem = targetItem;
    
}

// 添加自己的tabbar
- (void)addMyTabBar
{
    UIView *myTabBar = [[UIView alloc] init];
    [self.tabBar addSubview:myTabBar];
    myTabBar.frame = self.tabBar.bounds;
    self.tabBar.barStyle =UIBarStyleBlack;
    self.tabBar.layer.shadowPath =[UIBezierPath bezierPathWithRect:self.tabBar.layer.bounds].CGPath;
    self.tabBar.layer.shadowColor = [[UIColor lightGrayColor] CGColor];//阴影的颜色
    self.tabBar.layer.shadowOpacity = 1.0f;   // 阴影透明度
    self.tabBar.layer.shadowOffset = CGSizeMake(0.0,2.0f); // 阴影的范围
    self.tabBar.layer.shadowRadius = 2.0;  // 阴影扩散的范围控制
    myTabBar.backgroundColor = [UIColor whiteColor];
    
    // 添加5组Item
    CGFloat barWidth = myTabBar.frame.size.width;
    CGFloat itemheight = myTabBar.frame.size.height;
    CGFloat itemwidth = barWidth/5;
    
    UIView* gray_view = [[UIView alloc]init];
    gray_view.frame = CGRectMake(0, 0, barWidth, 0.5);
    gray_view.backgroundColor = RGB(223, 223, 223);
    [myTabBar addSubview:gray_view];
    
    // 首页
    UIControl *controlHome = [[UIControl alloc] init];
    self.controlHomeItem = controlHome;
    [myTabBar addSubview:controlHome];
    CGFloat controlHomeW = itemwidth;
    CGFloat controlHomeH = itemheight;
    CGFloat controlHomeX = 0 ;
    CGFloat controlHomeY = 0;
    controlHome.frame = CGRectMake(controlHomeX, controlHomeY, controlHomeW, controlHomeH);
    [controlHome addTarget:self action:@selector(controlHomeClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 图标
    UIImageView *imgViewHome = [[UIImageView alloc] init];
    [controlHome addSubview:imgViewHome];
    CGFloat imgViewHomeW = 23;
    CGFloat imgViewHomeH = 22;
    CGFloat imgViewHomeX = (itemwidth - imgViewHomeW) * 0.5;
    CGFloat imgViewHomeY = 6;
    imgViewHome.frame = CGRectMake(imgViewHomeX, imgViewHomeY, imgViewHomeW, imgViewHomeH);
    [imgViewHome setImage:[UIImage imageNamed:@"首页-未选中"]];
    imgViewHome.tag = 100;
    
    // 文字
    UILabel *labelHome = [[UILabel alloc] init];
    [controlHome addSubview:labelHome];
    labelHome.frame = CGRectMake(0, 28, itemwidth, 20);
    labelHome.text = @"首页";
    labelHome.font = [UIFont systemFontOfSize:11];
    labelHome.textColor =  RGB(153, 153, 153);
    labelHome.textAlignment = NSTextAlignmentCenter;
    labelHome.tag = 101;
    
    // 装修公司
    UIControl *controlBuildingMaterial = [[UIControl alloc] init];
    self.controlBuildingMaterialItem = controlBuildingMaterial;
    [myTabBar addSubview:controlBuildingMaterial];
    CGFloat controlBuildingMaterialW = itemwidth;
    CGFloat controlBuildingMaterialH = itemheight;
    CGFloat controlBuildingMaterialX = itemwidth;
    CGFloat controlBuildingMaterialY = 0;
    controlBuildingMaterial.frame = CGRectMake(controlBuildingMaterialX, controlBuildingMaterialY, controlBuildingMaterialW, controlBuildingMaterialH);
    controlBuildingMaterial.backgroundColor = [UIColor clearColor];
    [controlBuildingMaterial addTarget:self action:@selector(controlBuildingMaterialClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 图标
    UIImageView *imgViewBuildingMaterial = [[UIImageView alloc] init];
    [controlBuildingMaterial addSubview:imgViewBuildingMaterial];
    CGFloat imgViewBuildingMaterialW = 23;
    CGFloat imgViewBuildingMaterialH = 22;
    CGFloat imgViewBuildingMaterialX = (itemwidth - imgViewBuildingMaterialW) * 0.5;
    CGFloat imgViewBuildingMaterialY = 6;
    imgViewBuildingMaterial.frame = CGRectMake(imgViewBuildingMaterialX, imgViewBuildingMaterialY, imgViewBuildingMaterialW, imgViewBuildingMaterialH);
    [imgViewBuildingMaterial setImage:[UIImage imageNamed:@"装修公司-未选中"]];
    imgViewBuildingMaterial.tag = 100;
    
    // 文字
    UILabel *labelBuildingMaterial = [[UILabel alloc] init];
    [controlBuildingMaterial addSubview:labelBuildingMaterial];
    labelBuildingMaterial.frame = CGRectMake(0, 28, itemwidth, 20);
    labelBuildingMaterial.text = @"装修公司";
    labelBuildingMaterial.font = [UIFont systemFontOfSize:11];
    labelBuildingMaterial.textColor =  RGB(153, 153, 153);
    labelBuildingMaterial.textAlignment = NSTextAlignmentCenter;
    labelBuildingMaterial.tag = 101;
    
    // 家博会
    UIControl *controlHomeExpo = [[UIControl alloc] init];
    self.controlHomeExpoItem = controlHomeExpo;
    [myTabBar addSubview:controlHomeExpo];
    CGFloat controlHomeExpoW = itemwidth;
    CGFloat controlHomeExpoH = itemwidth;
    CGFloat controlHomeExpoX = itemwidth * 2;
    CGFloat controlHomeExpoY = 0;
    controlHomeExpo.frame = CGRectMake(controlHomeExpoX, controlHomeExpoY, controlHomeExpoW, controlHomeExpoH);
    controlHomeExpo.backgroundColor = [UIColor clearColor];
    [controlHomeExpo addTarget:self action:@selector(controlHomeExpoClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 圆形view
    UIView* viewWhite = [[UIView alloc]init];
    viewWhite.frame = CGRectMake(1, 0, itemwidth-8, itemwidth-8);
    viewWhite.backgroundColor = [UIColor whiteColor];
    viewWhite.layer.cornerRadius = (itemwidth-8)/2;
    //viewWhite.layer.masksToBounds = YES;
    viewWhite.userInteractionEnabled = NO;
    [controlHomeExpo addSubview:viewWhite];

    // 初始层
    CALayer *sublayer=[CALayer layer];
    sublayer.frame= CGRectMake(3, -11, itemwidth-8, itemwidth-8);
    sublayer.backgroundColor=[UIColor whiteColor].CGColor;
    sublayer.cornerRadius=(itemwidth-8)/2;
    sublayer.borderWidth = 0.5;
    sublayer.borderColor = RGB(223,223, 223).CGColor;

    //设置层的阴影效果
    sublayer.shadowOffset=CGSizeMake(0, 0.1f);
    sublayer.shadowColor=[UIColor lightGrayColor].CGColor;
    sublayer.shadowOpacity=0.2;
    sublayer.shadowOffset = CGSizeMake(0.0,0.1f);
    [viewWhite.layer addSublayer:sublayer];

    
    UIView* viewShade = [[UIView alloc]init];
    viewShade.frame = CGRectMake(0, 0.5, itemwidth, itemheight);
    viewShade.backgroundColor = [UIColor whiteColor];
    viewShade.userInteractionEnabled = NO;
    [controlHomeExpo addSubview:viewShade];
    
    // 图标
    UIImageView *imgViewHomeExpo = [[UIImageView alloc] init];
    [controlHomeExpo addSubview:imgViewHomeExpo];
    CGFloat imgViewHomeExpoW = 44;
    CGFloat imgViewHomeExpoH = 28;
    CGFloat imgViewHomeExpoX = (itemwidth - imgViewHomeExpoW) * 0.5; ;
    CGFloat imgViewHomeExpoY = 2;
    imgViewHomeExpo.frame = CGRectMake(imgViewHomeExpoX, imgViewHomeExpoY, imgViewHomeExpoW, imgViewHomeExpoH );
    [imgViewHomeExpo setImage:[UIImage imageNamed:@"家博会-未选中"]];
    imgViewHomeExpo.tag = 100;
    
    // 文字
    UILabel * labelHomeExpo = [[UILabel alloc] init];
    [controlHomeExpo addSubview:labelHomeExpo];
    labelHomeExpo.frame = CGRectMake(0, 28, itemwidth, 20);
    labelHomeExpo.text = @"家博会";
    labelHomeExpo.font = [UIFont systemFontOfSize:11];
    labelHomeExpo.textColor =  RGB(153, 153, 153);
    labelHomeExpo.textAlignment = NSTextAlignmentCenter;
    labelHomeExpo.tag = 101;
    
    // 建材家电
    UIControl *controlRenovation = [[UIControl alloc] init];
    self.controlRenovationItem = controlRenovation;
    [myTabBar addSubview:controlRenovation];
    CGFloat controlRenovationW = itemwidth;
    CGFloat controlRenovationH = itemheight;
    CGFloat controlRenovationX = itemwidth * 3;
    CGFloat controlRenovationY = 0;
    controlRenovation.frame = CGRectMake(controlRenovationX, controlRenovationY, controlRenovationW, controlRenovationH);
    [controlRenovation addTarget:self action:@selector(controlRenovationClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 图标
    UIImageView *imgViewRenovation = [[UIImageView alloc] init];
    [controlRenovation addSubview:imgViewRenovation];
    CGFloat imgViewRenovationW = 18;
    CGFloat imgViewRenovationH = 22;
    CGFloat imgViewRenovationX = (itemwidth - imgViewRenovationW) * 0.5  ;
    CGFloat imgViewRenovationY = 6;
    imgViewRenovation.frame = CGRectMake(imgViewRenovationX, imgViewRenovationY, imgViewRenovationW, imgViewRenovationH);
    [imgViewRenovation setImage:[UIImage imageNamed:@"建材家电-未选中"]];
    imgViewRenovation.tag = 100;
    
    // 文字
    UILabel * labelRenovation = [[UILabel alloc] init];
    [controlRenovation addSubview:labelRenovation];
    labelRenovation.frame = CGRectMake(0, 28, itemwidth, 20);
    labelRenovation.text = @"建材家电";
    labelRenovation.font = [UIFont systemFontOfSize:11];
    labelRenovation.textColor =  RGB(153, 153, 153);
    labelRenovation.textAlignment = NSTextAlignmentCenter;
    labelRenovation.tag = 101;
    
    //我的
    UIControl *controlMy = [[UIControl alloc] init];
    self.controlMyItem = controlMy;
    [myTabBar addSubview:controlMy];
    CGFloat controlMyW = itemwidth;
    CGFloat controlMyH = itemheight;
    CGFloat controlMyX = itemwidth * 4;
    CGFloat controlMyY = 0;
    controlMy.frame = CGRectMake(controlMyX, controlMyY, controlMyW, controlMyH);
    [controlMy addTarget:self action:@selector(controlMyClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 图标
    UIImageView *imgViewMy = [[UIImageView alloc] init];
    [controlMy addSubview:imgViewMy];
    CGFloat imgViewMyW = 23;
    CGFloat imgViewMyH = 22;
    CGFloat imgViewMyX = (itemwidth - imgViewMyW) * 0.5  ;
    CGFloat imgViewMyY = 6;
    imgViewMy.frame = CGRectMake(imgViewMyX, imgViewMyY, imgViewMyW, imgViewMyH);
    [imgViewMy setImage:[UIImage imageNamed:@"我的-未选中"]];
    imgViewMy.tag = 100;
    
    // 文字
    UILabel *labelMy = [[UILabel alloc] init];
    [controlMy addSubview:labelMy];
    labelMy.frame = CGRectMake(0, 28, itemwidth, 20);
    labelMy.text = @"我的";
    labelMy.font = [UIFont systemFontOfSize:11];
    labelMy.textColor =  RGB(153, 153, 153);
    labelMy.textAlignment = NSTextAlignmentCenter;
    labelMy.tag = 101;
    
}
-(void)loadLOcation{
    
    [[XWLocationManager sharedXWLocationManager] getCurrentLocation:^(CLLocation *location, CLPlacemark *placeMark, NSString *error) {
        if (error) {
            NSLog(@"定位出错,错误信息:%@",error);
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"定位失败，请检查您的网络或者在设置中允许定位" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action1];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            
            
            NSLog(@"%@",placeMark.locality);
           
        }
        
    } onViewController:self];
    
}

@end
