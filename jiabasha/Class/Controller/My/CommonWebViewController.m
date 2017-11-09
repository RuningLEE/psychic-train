//
//  CommonWebViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/16.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CommonWebViewController.h"
#import "GetContentRequest.h"
#import "AdContent.h"
#import "CommonUtils.h"
#import "UserAgentManager.h"

@interface CommonWebViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *paramStr;
@end

@implementation CommonWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    if (_sourceType == 1) {
        _labelTitle.text = @"我的签到礼";
        _paramStr = @"h5_sign_in";
    } else if (_sourceType == 2){
        _labelTitle.text = @"我要索票";
        _paramStr = @"h5_get_ticket";
    } else if (_sourceType == 3){
       _labelTitle.text = @"关于中国婚博会——家芭莎";
        _paramStr = @"h5_about_us";
    } else {
    
    }
    [self getAdRequest];
}

#pragma mark - Request

- (void)getAdRequest{
    __weak typeof(self) weakSelf = self;
    [GetContentRequest requestWithParameters:@{@"ad_location_name":_paramStr}
                               withCacheType:DataCacheManagerCacheTypeMemory
                           withIndicatorView:nil
                           withCancelSubject:[GetContentRequest getDefaultRequstName]
                              onRequestStart:nil
                           onRequestFinished:^(CIWBaseDataRequest *request) {
                               if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                   //刷新数据
                                   AdContent *content = (AdContent *)[[request.resultDic objectForKey:@"AdContent"] firstObject];
                                   [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:content.contentUrl]]];
                               }
                           }
                           onRequestCanceled:^(CIWBaseDataRequest *request) {
                               //[_tableViewSelected.mj_header endRefreshing];
                           }
                             onRequestFailed:^(CIWBaseDataRequest *request) {
                                 //[_tableViewSelected.mj_header endRefreshing];
                             }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [CommonUtils addLoginTokenToWebCookiesWithHostName:@"jiehun.com.cn"];
    [CommonUtils addLoginTokenToWebCookiesWithHostName:@"jiabasha.com"];
    
    [UserAgentManager settingUserAgent];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
