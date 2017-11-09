//
//  QuestionDetailViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/4.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "HelpCenterHeaderTableViewCell.h"
#import "HelpContentTableViewCell.h"
#import "GetHelpCenterRequest.h"//请求详情
#import "HelpCenterDetialModel.h"
#import "UserAgentManager.h"
#import "CommonUtils.h"

@interface QuestionDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HelpCenterDetialModel *detailModel;
@property (weak, nonatomic) IBOutlet UIWebView *webviewMain;
@property (strong, nonatomic) IBOutlet UIView *viewFooter;
@property (strong, nonatomic) CIWMaskActivityView *activityView;
@property (strong, nonatomic) IBOutlet UIView *viewNotify;
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) IBOutlet UILabel *labelMobile;
@end

@implementation QuestionDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _viewNotify.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:_viewNotify];
    _viewNotify.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.webviewMain.scrollView removeObserver:self
//                                 forKeyPath:@"contentSize" context:@"ThisIsMyKVOContextNotSuper"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewBg.layer.cornerRadius = 5;
    _viewBg.layer.masksToBounds = YES;
    if ([DATA_ENV.city.cityId isEqualToString:@"330100"]) {
        _labelMobile.text = @"0571-28198188";
    } else {
        _labelMobile.text = @"4000-365-520";
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"HelpCenterHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"headerCell"];
//    [self.webviewMain.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:@"ThisIsMyKVOContextNotSuper"];
    self.webviewMain.delegate = self;
    [self GetHelpDetailRequest];
    
    [CommonUtils addLoginTokenToWebCookiesWithHostName:@"jiehun.com.cn"];
    [CommonUtils addLoginTokenToWebCookiesWithHostName:@"jiabasha.com"];
    
    [UserAgentManager settingUserAgent];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFooterViewWithHeight:(CGFloat)height{
    if ([CommonUtil isEmpty:self.detailModel.contentText]) {
        self.viewFooter.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 50);
        _tableView.tableFooterView = _viewFooter;
        [_tableView reloadData];
    }else{
        _viewFooter.frame = CGRectMake(0, 0, kScreenWidth, height+10+20);
        _tableView.tableFooterView = _viewFooter;
        [_tableView reloadData];
    }
}

#pragma mark - UIWebview Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self setFooterViewWithHeight:webView.scrollView.contentSize.height];
    [_activityView hide];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
    [_activityView hide];
}

#pragma mark - Request
- (void)GetHelpDetailRequest{
    __weak typeof(self) WeakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_contentId,@"content_id", nil];
    [GetHelpCenterRequest requestWithParameters:param withIsCacheData:NO withIndicatorView:self.view withCancelSubject:[GetHelpCenterRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([RESPONSE_OK isEqualToString:request.errCode]) {
            _detailModel = (HelpCenterDetialModel *)[request.resultDic objectForKey:@"detailModel"];
            [WeakSelf.tableView reloadData];
            if (![CommonUtil isEmpty:_detailModel.contentText]) {
                [WeakSelf.webviewMain loadHTMLString:_detailModel.contentText baseURL:nil];
                _activityView = [CIWMaskActivityView loadFromXib];
                [_activityView showInView:self.view];
                [_tableView reloadData];
            } else {
                WeakSelf.viewFooter.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight-50-60-20);
                 WeakSelf.tableView.tableFooterView = WeakSelf.viewFooter;
                 [WeakSelf.tableView reloadData];
            }
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callCustomerAction:(id)sender {
    _viewNotify.hidden = NO;
}

- (IBAction)cancelCall:(id)sender {
    _viewNotify.hidden = YES;
}

- (IBAction)callMethod:(id)sender {
    if (![CommonUtil isEmpty:_labelMobile.text]) {
        NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",_labelMobile.text]; //而这个方法则打电话前先弹框 是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    }
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        HelpCenterHeaderTableViewCell *headerdcell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        headerdcell.selectionStyle = UITableViewCellSelectionStyleNone;
        headerdcell.labelTitle.text = _detailModel.contentTitle;
        return headerdcell;
}

@end
