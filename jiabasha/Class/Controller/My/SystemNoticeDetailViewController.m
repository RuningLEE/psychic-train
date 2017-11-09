//
//  SystemNoticeDetailViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/3.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "SystemNoticeDetailViewController.h"
#import "SetNoticeReadRequest.h"

@interface SystemNoticeDetailViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewNotify;
@property (weak, nonatomic) IBOutlet UIView *viewNotifyBgView;
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (strong, nonatomic) CIWMaskActivityView *viewActivity;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@end

@implementation SystemNoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self setReadRequest];
    // Do any additional setup after loading the view from its nib.
}

//设置子控件
- (void)setUp{
    _viewNotify.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:_viewNotify];
    _viewNotify.hidden = YES;
    _viewNotifyBgView.layer.cornerRadius = 5;
    _viewNotifyBgView.layer.masksToBounds = YES;
    _mainWebView.delegate = self;
    [_mainWebView loadHTMLString:_stringHtml baseURL:nil];
    if ([DATA_ENV.city.cityId isEqualToString:@"330100"]) {
        _labelPhone.text = @"0571-28198188";
    } else {
        _labelPhone.text = @"4000-365-520";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request

- (void)setReadRequest{
    //"noticeId": "26718907","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_noticeId,@"notice_id", nil];
    [SetNoticeReadRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[SetNoticeReadRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([RESPONSE_OK isEqualToString:request.errCode]) {
            NSLog(@"设置已读成功");
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
    
}

#pragma mark - UIWebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _viewActivity = [CIWMaskActivityView loadFromXib];
    [_viewActivity showInView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_viewActivity hide];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_viewActivity hide];
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//电话客服
- (IBAction)callToCustom:(id)sender {
    _viewNotify.hidden = NO;
}
//点击取消btn
- (IBAction)btnCancelClicked:(id)sender {
    _viewNotify.hidden = YES;
}
//点击呼叫btn
- (IBAction)btnCallClicked:(id)sender {
    if (![CommonUtil isEmpty:_labelPhone.text]) {
        NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",_labelPhone.text]; //而这个方法则打电话前先弹框 是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    }
    _viewNotify.hidden = YES;
}
@end
