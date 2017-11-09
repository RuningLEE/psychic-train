//
//  ScanViewController.m
//  aicixi
//
//  Created by 金伟城 on 16/10/31.
//  Copyright © 2016年 daoshun. All rights reserved.
//

#import "ScanViewController.h"
#import "WebViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MyViewController.h"//wode
#import "LoginViewController.h"//login
#import "HomeViewController.h"//home
#import "MessageViewController.h"//information
#import "ActivityListViewController.h"
#import "AppointDesignViewController.h"
#import "DecorateViewController.h"
#import "RenovationCategoryViewController.h"
#import "CouponViewController.h"
#import "BuildingMaterialViewController.h"
#import "AppDelegate.h"
@interface ScanViewController ()<UITabBarDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    BOOL upOrdown ;
    NSInteger num ;
}

@property (weak, nonatomic) IBOutlet UIImageView *scanLineImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanLineTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *customLabel;
@property (weak, nonatomic) IBOutlet UIView *customContainerView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
;
@property (weak, nonatomic) IBOutlet UIView *scanLine;

@property ( strong , nonatomic ) AVCaptureDevice * device;
@property ( strong , nonatomic ) AVCaptureDeviceInput * input;
@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;
@property ( strong , nonatomic ) AVCaptureSession * session;
@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * previewLayer;
@property (strong, nonatomic) NSTimer *lineTimer;

/*** 专门用于保存描边的图层 ***/
@property (nonatomic,strong) CALayer *containerLayer;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.tabBarController.tabBar.hidden = YES;
    // 开始扫描二维码
    [self startScan];
    
    upOrdown = NO;
    num = 0;
    self.lineTimer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    self.lineView.layer.borderColor = RGB(56, 195, 255).CGColor;
    self.lineView.layer.borderWidth = 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
//返回
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -------- 懒加载---------
- (AVCaptureDevice *)device
{
    if (_device == nil) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCaptureDeviceInput *)input
{
    if (_input == nil) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}

- (AVCaptureSession *)session
{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (_previewLayer == nil) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    return _previewLayer;
}
// 设置输出对象解析数据时感兴趣的范围
// 默认值是 CGRect(x: 0, y: 0, width: 1, height: 1)
// 通过对这个值的观察, 我们发现传入的是比例
// 注意: 参照是以横屏的左上角作为, 而不是以竖屏
//        out.rectOfInterest = CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
- (AVCaptureMetadataOutput *)output
{
    if (_output == nil) {
        _output = [[AVCaptureMetadataOutput alloc] init];
        
        // 1.获取屏幕的frame
        CGRect viewRect = self.view.frame;
        // 2.获取扫描容器的frame
        CGRect containerRect = self.customContainerView.frame;
        
//        CGFloat x = containerRect.origin.y / viewRect.size.height;
//        CGFloat y = containerRect.origin.x / viewRect.size.width;
//        CGFloat width = containerRect.size.height / viewRect.size.height;
//        CGFloat height = containerRect.size.width / viewRect.size.width;
        
        // CGRect outRect = CGRectMake(x, y, width, height);
        // [_output rectForMetadataOutputRectOfInterest:outRect];
//        _output.rectOfInterest = CGRectMake(0, 0, width, height);
        _output.rectOfInterest =self.view.bounds;
    }
    return _output;
}

- (CALayer *)containerLayer
{
    if (_containerLayer == nil) {
        _containerLayer = [[CALayer alloc] init];
    }
    return _containerLayer;
}

- (void)startScan
{
    // 1.判断输入能否添加到会话中
    if (![self.session canAddInput:self.input]) return;
    [self.session addInput:self.input];
    
    
    // 2.判断输出能够添加到会话中
    if (![self.session canAddOutput:self.output]) return;
    [self.session addOutput:self.output];
    
    // 4.设置输出能够解析的数据类型
    // 注意点: 设置数据类型一定要在输出对象添加到会话之后才能设置
    self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes;
    
    // 5.设置监听监听输出解析到的数据
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 6.添加预览图层
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    self.previewLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    // 7.添加容器图层
    [self.view.layer addSublayer:self.containerLayer];
    self.containerLayer.frame = self.view.bounds;
    
    // 8.开始扫描
    [self.session startRunning];
}

#pragma mark --------AVCaptureMetadataOutputObjectsDelegate ---------
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // id 类型不能点语法,所以要先去取出数组中对象
    AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];

   

    if (object == nil) return;
    // 只要扫描到结果就会调用
    NSString *str = object.stringValue;
     [self.view makeToast:str];
    self.customLabel.text = str;
    NSString *wenUrl;
    if(str.length >4){
        wenUrl = [str substringToIndex:4];
    }
       // 是否包含
    if([wenUrl isEqualToString:@"http"])
    {
        WebViewController *view = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        view.urlString = str;
//        [self.navigationController pushViewController:view animated:YES];
        NSArray *array = [self.navigationController.viewControllers subarrayWithRange:NSMakeRange(0, self.navigationController.viewControllers.count - 1)];
        NSMutableArray *viewControllers = [array mutableCopy];
        [viewControllers addObject:view];
        
        self.navigationController.viewControllers = viewControllers;
    }else{
        [self.view makeToast:str];
    }
   

     if ([@"jbs://hot_activities/" isEqualToString:object.stringValue]) {
        //热门活动
        ActivityListViewController *viewContoller = [[ActivityListViewController alloc] init];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://order_design/" isEqualToString:object.stringValue]) {
        //预约设计
        AppointDesignViewController *viewContoller = [[AppointDesignViewController alloc] init];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://decorate_assistant/" isEqualToString:object.stringValue]) {
        //装修助手
        DecorateViewController *viewContoller = [[DecorateViewController alloc] init];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://cash_ticket/" isEqualToString:object.stringValue]) {
        //现金券
        CouponViewController *viewContoller = [[CouponViewController alloc] init];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://cabinet_electric/" isEqualToString:object.stringValue]) {
        //橱柜厨电
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
       viewContoller.strStyle = @"橱柜厨电";
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://bathroom_accessory_ceramic/" isEqualToString:object.stringValue]) {
        //卫浴陶瓷
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = @"卫浴陶瓷";
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://floor_board_windows/" isEqualToString:object.stringValue]) {
        //地板门窗
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle =@"地板门窗";
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://house_furniture/" isEqualToString:object.stringValue]) {
        //住宅家具
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = @"住宅家具";
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://furniture_soft_decoration/" isEqualToString:object.stringValue]) {
        //家居软装
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = @"家居软装";
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://base_building_materials/" isEqualToString:object.stringValue]) {
        //基础建材
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = @"基础建材";
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://big_household_appliances/" isEqualToString:object.stringValue]) {
        //大家电
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = @"大家电";
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://decorate_company/" isEqualToString:object.stringValue]) {
        //装修公司
                AppDelegate *appDelegate = APP_DELEGATE;
        [appDelegate.MyTabBarController controlBuildingMaterialClick];
        
    } else if ([@"jbs://login/" isEqualToString:object.stringValue]) {
        //登陆
        [[NSNotificationCenter defaultCenter] postNotificationName:@"needlogin" object:nil];
        
    } else if ([@"jbs://home/" isEqualToString:object.stringValue]) {
        //首页
       
        AppDelegate *appDelegate = APP_DELEGATE;
        [appDelegate.MyTabBarController controlHomeClick];
        
    } else if ([@"jbs://mine/" isEqualToString:object.stringValue]) {
        //我的
        
        AppDelegate *appDelegate = APP_DELEGATE;
        [appDelegate.MyTabBarController controlMyClick];
        
    } else if ([@"jbs://message/" isEqualToString:object.stringValue]) {
        //消息中心
        if (DATA_ENV.isLogin) {
            MessageViewController* messageController = [[MessageViewController alloc]init];
            [self.navigationController pushViewController:messageController animated:YES];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"needlogin" object:nil];
        }
    }
//    else {
//        [self openWebView:category.contentUrl];
//    }
//
    

    // 清除之前的描边
    [self clearLayers];
    
    // 对扫描到的二维码进行描边
//    AVMetadataMachineReadableCodeObject *obj = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:object];
    
    // 绘制描边
//    [self drawLine:obj];
    
   
    

    
}
// 绘制描边
- (void)drawLine:(AVMetadataMachineReadableCodeObject *)objc
{
    NSArray *array = objc.corners;
    
    // 1.创建形状图层, 用于保存绘制的矩形
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    
    // 设置线宽
    layer.lineWidth = 2;
    // 设置描边颜色
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    // 2.创建UIBezierPath, 绘制矩形
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint point = CGPointZero;
    int index = 0;
    
    CFDictionaryRef dict = (__bridge CFDictionaryRef)(array[index++]);
    // 把点转换为不可变字典
    // 把字典转换为点，存在point里，成功返回true 其他false
    CGPointMakeWithDictionaryRepresentation(dict, &point);
    
    // 设置起点
    [path moveToPoint:point];
    
    // 2.2连接其它线段
    for (int i = 1; i<array.count; i++) {
        CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)array[i], &point);
        [path addLineToPoint:point];
    }
    // 2.3关闭路径
    [path closePath];
    
    layer.path = path.CGPath;
    // 3.将用于保存矩形的图层添加到界面上
    [self.containerLayer addSublayer:layer];
}

- (void)clearLayers
{
    if (self.containerLayer.sublayers)
    {
        for (CALayer *subLayer in self.containerLayer.sublayers)
        {
            [subLayer removeFromSuperlayer];
        }
    }
}

//注意，在界面消失的时候关闭session
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.session stopRunning];
}

// 界面显示,开始动画
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startAnimation];
   
}
// 开启冲击波动画
- (void)startAnimation
{
    // 1.设置冲击波底部和容器视图顶部对齐
    self.scanLineTopConstraint.constant = - self.containerHeightConstraint.constant;
    // 刷新UI
    [self.view layoutIfNeeded];
    
    // 2.执行扫描动画
    [UIView animateWithDuration:1.3 animations:^{
        // 无线重复动画
        [UIView setAnimationRepeatCount:MAXFLOAT];
        self.scanLineTopConstraint.constant = self.containerHeightConstraint.constant;
        // 刷新UI
        [self.view layoutIfNeeded];
    } completion:nil];
}



//扫描线动画
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        CGRect frame = self.scanLine.frame;
        frame.origin.y = 0 + 2*num;
        self.scanLine.frame = frame;
        
        if (2*num >= 300) {
           // upOrdown = YES;
            num = 0;
            CGRect frame = self.scanLine.frame;
            frame.origin.y = 0 ;
            self.scanLine.frame = frame;
        }
    }
    else {
        num --;
        CGRect frame = self.scanLine.frame;
        frame.origin.y = 0 + 2*num;
        self.scanLine.frame = frame;
        
        if (num <= 0) {
            upOrdown = NO;
        }
    }
    
}

@end
