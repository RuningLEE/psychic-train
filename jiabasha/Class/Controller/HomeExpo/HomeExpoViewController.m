//
//  HomeExpoViewController.m
//  JiaZhuang
//
//  Created by 金伟城 on 16/12/26.
//  Copyright © 2016年 hzdaoshun. All rights reserved.
//

#import "HomeExpoViewController.h"
#import "GetContentRequest.h"
#import "AdContent.h"
#import "CommonUtils.h"
#import "UserAgentManager.h"

@interface HomeExpoViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) AdContent *adContent;

@end

@implementation HomeExpoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [CommonUtils addLoginTokenToWebCookiesWithHostName:@"jiehun.com.cn"];
    [CommonUtils addLoginTokenToWebCookiesWithHostName:@"jiabasha.com"];
    
    [UserAgentManager settingUserAgent];
    
    [self getAdContent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAdContent) name:@"CityChanged" object:nil];
}

//取广告数据
- (void)getAdContent {
    [self.webView loadHTMLString:@"" baseURL:nil];
    
    __weak typeof(self) weakSelf = self;
    [GetContentRequest requestWithParameters:@{@"ad_location_name":@"h5_tab_jiabohui"}
                               withCacheType:DataCacheManagerCacheTypeMemory
                           withIndicatorView:self.view
                           withCancelSubject:[GetContentRequest getDefaultRequstName]
                              onRequestStart:nil
                           onRequestFinished:^(CIWBaseDataRequest *request) {
                               if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                   
                                   if ([request.resultDic objectForKey:KEY_ADCONTENT]) {
                                       
                                       NSArray *array = [request.resultDic objectForKey:KEY_ADCONTENT];
                                       
                                       if (array.count > 0) {
                                           weakSelf.adContent = array[0];
                                           NSString *urlString = [weakSelf.adContent.contentUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                           
                                           NSURL *url = [[NSURL alloc] initWithString:urlString];
                                           [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:url]];
                                       }
                                       
                                   }
                               }
                           }
                           onRequestCanceled:^(CIWBaseDataRequest *request) {
                               //[_tableViewSelected.mj_header endRefreshing];
                           }
                             onRequestFailed:^(CIWBaseDataRequest *request) {
                                 //[_tableViewSelected.mj_header endRefreshing];
                             }];
    
}

@end
