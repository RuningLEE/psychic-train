//
//  DecorateViewController.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/11.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "DecorateViewController.h"
#import "GetHomeAssistaneRequest.h"
#import "Decorate.h"
#import "WebViewController.h"
#import "InspectionViewController.h"

@interface DecorateViewController () {
    
    __weak IBOutlet UIView *_viewZxread;
    __weak IBOutlet NSLayoutConstraint *_heightForRead;
    __weak IBOutlet UIView *_viewZxing;
    __weak IBOutlet NSLayoutConstraint *_heightForZxing;
}

@property (nonatomic, strong) NSArray *zxreadList;
@property (nonatomic, strong) NSArray *zxingList;

@end

@implementation DecorateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getHomeAssistaneRequest];
}

- (void)getHomeAssistaneRequest
{
    __weak typeof(self) weakSelf = self;
    [GetHomeAssistaneRequest requestWithParameters:nil// 参数
                            withIndicatorView:self.view//网络加载视图加载到某个view
                               onRequestStart:^(CIWBaseDataRequest *request) {}
                            onRequestFinished:^(CIWBaseDataRequest *request) {
                                
                                if([request.errCode isEqualToString:RESPONSE_OK]){
                                    NSArray *array = [request.resultDic objectForKey:KEY_ZXREAD];

                                    //准备装修
                                    if(array.count){
                                        weakSelf.zxreadList = array;
                                    }
                                    
                                    //正常装修
                                    array = [request.resultDic objectForKey:KEY_ZXIND];
                                    if(array.count){
                                        weakSelf.zxingList = array;
                                    }
                                    
                                    [weakSelf displayAssistane];
                                }
                            }
     
                            onRequestCanceled:^(CIWBaseDataRequest *request) {}
                              onRequestFailed:^(CIWBaseDataRequest *request) {}];
}



- (void)displayAssistane {
    
    CGFloat maxWidth = kScreenWidth - 20;
    
    //装修准备
    CGFloat start_x = 0;
    int row = 0;
    
    for (int i = 0;i< self.zxreadList.count; i++) {
        Decorate *decorate = [self.zxreadList objectAtIndex:i];
        
        CGFloat _width = [decorate.contentTitle getSizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(MAXFLOAT, 20)].width + 30.0;
        _width = MIN(_width, maxWidth);
        
        if (_width > maxWidth - start_x) {
            
            row++;
            start_x = 0;
        }
        
        UIButton *button = [self buttonForZX];
        button.frame = CGRectMake(start_x, (36 + 12) * row, _width, 36);
        [button setTitle:decorate.contentTitle forState:UIControlStateNormal];
        [_viewZxread addSubview:button];
        button.tag = i;
        
        [button addTarget:self action:@selector(zxreadClick:) forControlEvents:UIControlEventTouchUpInside];
        
        start_x = start_x + _width + 10;
    }
    
    _heightForRead.constant = (row + 1) * 48 - 12;
    
    //正在装修
    start_x = 0;
    row = 0;
    
    for (int i = 0;i< self.zxingList.count; i++) {
        Decorate *decorate = [self.zxingList objectAtIndex:i];
        
        CGFloat _width = [decorate.contentTitle getSizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(MAXFLOAT, 20)].width + 30.0;
        _width = MIN(_width, maxWidth);
        
        if (_width > maxWidth - start_x) {
            
            row++;
            start_x = 0;
        }
        
        UIButton *button = [self buttonForZX];
        button.frame = CGRectMake(start_x, (36 + 12) * row, _width, 36);
        [button setTitle:decorate.contentTitle forState:UIControlStateNormal];
        [_viewZxing addSubview:button];
        button.tag = i;
        
        [button addTarget:self action:@selector(zxingClick:) forControlEvents:UIControlEventTouchUpInside];
        
        start_x = start_x + _width + 10;
    }
    
    _heightForZxing.constant = (row + 1) * 48 - 12;
    
}

- (UIButton *)buttonForZX {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [button setTitleColor:RGBFromHexColor(0x666666) forState:UIControlStateNormal];
    [button setBackgroundColor:RGBFromHexColor(0xe8e8e8)];
    button.layer.cornerRadius = 2.0;
    button.layer.masksToBounds = YES;
    return button;
}

#pragma mark - actions
//返回
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//装修准备
- (void)zxreadClick:(UIButton *)button {
    //我要验房
    if ([button.currentTitle isEqualToString:@"我要验房"]) {
        InspectionViewController *inspectionViewController = [[InspectionViewController alloc] initWithNibName:@"InspectionViewController" bundle:nil];
        [self.navigationController pushViewController:inspectionViewController animated:YES];
        return;
    }
    
    Decorate *decorate = [self.zxreadList objectAtIndex:button.tag];
    [self openWebView:decorate.contentUrl];
}

//正在装修
- (void)zxingClick:(UIButton *)button {
    Decorate *decorate = [self.zxingList objectAtIndex:button.tag];
    [self openWebView:decorate.contentUrl];
}

- (void)openWebView:(NSString *)urlstring {
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewController.urlString = urlstring;
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
