//
//  HelpCenterViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/4.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "HelpCenterTableViewCell.h"
#import "QuestionDetailViewController.h"
#import "SubControllerOfHelpCenterViewController.h"
#import "GetHelpCenterDataRequest.h"
#import "HelpCenterQuestionModel.h"
#import "Banner.h"
#import "LCBannerView.h"
#import "WebViewController.h"
#import "UIColor-Expanded.h"
#import "GetContentRequest.h"
#import "AdContent.h"
#import "categoryModel.h"

@interface HelpCenterViewController ()<UITableViewDelegate,UITableViewDataSource,LCBannerViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewBanner;
@property (strong, nonatomic) NSMutableArray *arrQuestion;
@property (weak, nonatomic) IBOutlet UIView *viewFreeTicket;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constantViewBannerHeight;
@property (weak, nonatomic) IBOutlet UIView *viewOrder;
@property (weak, nonatomic) IBOutlet UIView *viewAccount;
@property (weak, nonatomic) IBOutlet UIView *viewPrivilege;
@property (strong, nonatomic) NSArray *bannerTipsList;
@property (strong, nonatomic) IBOutlet UIView *viewNotify;
@property (strong, nonatomic) NSArray *arrAd;
@property (weak, nonatomic) IBOutlet UILabel *labelMobile;
@property (weak, nonatomic) IBOutlet UIView *viewCallBG;
@property (strong, nonatomic) NSArray *arrCategory;
@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    
    [self initUIGestureRecognizer];
    
    [self GetHelpRequest];
    //顶部轮播数据
    [self getAdRequest];
    //设定轮播图
    [self setupViewBanner];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _viewNotify.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:_viewNotify];
    _viewNotify.hidden = YES;
}

- (void)setUp{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGB(246, 246, 246);
    [_tableView registerNib:[UINib nibWithNibName:@"HelpCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"helpCell"];
    _viewBanner.clipsToBounds = YES;
    _viewCallBG.layer.cornerRadius = 5;
    _viewCallBG.layer.masksToBounds = YES;
    if ([DATA_ENV.city.cityId isEqualToString:@"330100"]) {
        _labelMobile.text = @"0571-28198188";
    } else {
        _labelMobile.text = @"4000-365-520";
    }
}

- (NSArray *)arrAd
{
    if (_arrAd == nil) {
        _arrAd = [NSArray array];
    }
    return _arrAd;
}

- (NSArray *)arrCategory{
    if (_arrCategory == nil) {
        _arrCategory = [NSArray array];
    }
    return _arrCategory;
}

#pragma mark - Request

- (void)getAdRequest{
    __weak typeof(self) weakSelf = self;
    [GetContentRequest requestWithParameters:@{@"ad_location_name":@"myhome_help_top_1080x1920"}
                               withCacheType:DataCacheManagerCacheTypeMemory
                           withIndicatorView:nil
                           withCancelSubject:[GetContentRequest getDefaultRequstName]
                              onRequestStart:nil
                           onRequestFinished:^(CIWBaseDataRequest *request) {
                               if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                   //刷新数据
                                   weakSelf.arrAd = [request.resultDic objectForKey:@"AdContent"];
                                   [self setupViewBanner];
                                   [weakSelf.tableView reloadData];
                               }
                           }
                           onRequestCanceled:^(CIWBaseDataRequest *request) {
                               //[_tableViewSelected.mj_header endRefreshing];
                           }
                             onRequestFailed:^(CIWBaseDataRequest *request) {
                                 //[_tableViewSelected.mj_header endRefreshing];
                             }];
}

//设定轮播图
- (void)setupViewBanner{
    NSMutableArray *urls = [NSMutableArray arrayWithCapacity:self.arrAd.count];
    //设定轮播图高度
    if (self.arrAd.count == 0) {
        self.constantViewBannerHeight.constant = 0;
        _viewHeader.frame = CGRectMake(0, 0, kScreenWidth, 132);
        _tableView.tableHeaderView = _viewHeader;
    }else{
        self.constantViewBannerHeight.constant = 130;
        _viewHeader.frame = CGRectMake(0, 0, kScreenWidth, 262);
        _tableView.tableHeaderView = _viewHeader;
    }
    if (self.arrAd.count != 0) {
        for (AdContent *ad in self.arrAd) {
            [urls addObject:ad.contentPicUrl];
        }
    }
    
    if (urls.count > 0) {
        NSInteger time;
        if (urls.count>1) {
            time=2.0;
        }else{
            time=100000;
        }

        //轮播图
        LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, kScreenWidth, 130)
                                                            delegate:self
                                                           imageURLs:urls
                                                placeholderImageName:nil
                                                        timeInterval:time
                                       currentPageIndicatorTintColor:[UIColor colorWithHexString:@"#601986"]
                                              pageIndicatorTintColor:[UIColor colorWithHexString:@"#aaa49e"]];
        bannerView.tag = 1;
        [_viewBanner addSubview:bannerView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUIGestureRecognizer{
    [_viewFreeTicket addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelCLickWithUIGesture:)]];
    [_viewOrder addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelCLickWithUIGesture:)]];
    [_viewAccount addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelCLickWithUIGesture:)]];
    [_viewPrivilege addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelCLickWithUIGesture:)]];
    _viewFreeTicket.tag = 1;
    _viewOrder.tag      = 2;
    _viewAccount.tag    = 3;
    _viewPrivilege.tag  = 4;
}

#pragma mark - Request
- (void)GetHelpRequest{
    __weak typeof(self)WeakSelf = self;
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"110900", @"city_id",@"100",@"app_id",@"09f8dcf852d1254c490342c1a05db1dc",@"app_secret", nil];
    [GetHelpCenterDataRequest requestWithParameters:nil withIsCacheData:YES withIndicatorView:self.view withCancelSubject:[GetHelpCenterDataRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
     
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            WeakSelf.arrQuestion = [request.resultDic objectForKey:@"arrQuesModel"];
            WeakSelf.arrCategory = [request.resultDic objectForKey:@"arrCategofyModel"];
            [WeakSelf.tableView reloadData];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

#pragma mark - lazyinit
- (NSMutableArray *)arrQuestion
{
    if (_arrQuestion == nil) {
        _arrQuestion = [NSMutableArray array];
    }
    return _arrQuestion;
}

- (NSArray *)bannerSelectedList
{
    if (_bannerTipsList == nil) {
        _bannerTipsList = [NSArray array];
    }
    return _bannerTipsList;
}

#pragma mark - labelClick
- (void)labelCLickWithUIGesture:(UITapGestureRecognizer *)tap{
    NSInteger tag = tap.view.tag;
    if (tag == 1) {//点击索票
        categoryModel *quesModel = (categoryModel *)[self.arrCategory objectAtIndex:0];
        SubControllerOfHelpCenterViewController *subController = [[SubControllerOfHelpCenterViewController alloc]init];
        subController.Title = @"索票相关";
        subController.categoryId = quesModel.categoryId;
        [self.navigationController pushViewController:subController animated:YES];
    }else if (tag == 2){//订单
        categoryModel *quesModel = (categoryModel *)[self.arrCategory objectAtIndex:1];
        SubControllerOfHelpCenterViewController *subController = [[SubControllerOfHelpCenterViewController alloc]init];
        subController.Title = @"订单相关";
        subController.categoryId = quesModel.categoryId;
        [self.navigationController pushViewController:subController animated:YES];
    }else if (tag == 3){//账户
        categoryModel *quesModel = (categoryModel *)[self.arrCategory objectAtIndex:2];
        SubControllerOfHelpCenterViewController *subController = [[SubControllerOfHelpCenterViewController alloc]init];
        subController.Title = @"账户相关";
        subController.categoryId = quesModel.categoryId;
        [self.navigationController pushViewController:subController animated:YES];
    }else if (tag == 4){//优惠券
        categoryModel *quesModel = (categoryModel *)[self.arrCategory objectAtIndex:3];
        SubControllerOfHelpCenterViewController *subController = [[SubControllerOfHelpCenterViewController alloc]init];
        subController.Title = @"优惠券相关";
        subController.categoryId = quesModel.categoryId;
        [self.navigationController pushViewController:subController animated:YES];
    }
}


#pragma mark - ButtonClick
- (IBAction)callCustomerAction:(id)sender {
    _viewNotify.hidden = NO;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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


#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrQuestion.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelpCenterQuestionModel *quesModel = (HelpCenterQuestionModel*)[self.arrQuestion objectAtIndex:indexPath.row];
    NSString *ID = @"helpCell";
    HelpCenterTableViewCell* helpCell = [tableView dequeueReusableCellWithIdentifier:ID];
    helpCell.labelQuestion.text = quesModel.contentTitle;
    helpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return helpCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelpCenterQuestionModel *quesModel = (HelpCenterQuestionModel*)[self.arrQuestion objectAtIndex:indexPath.row];
    QuestionDetailViewController *quesController = [[QuestionDetailViewController alloc]init];
    quesController.contentId = quesModel.contentId;
    [self.navigationController pushViewController:quesController animated:YES];
}

//轮播图点击
- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index
{
    AdContent *adModel = nil;
    adModel = [self.arrAd objectAtIndex:index];
    [self openWebView:adModel.contentUrl];
}

- (void)openWebView:(NSString *)urlstring {
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewController.urlString = urlstring;
    [self.navigationController pushViewController:webViewController animated:YES];
}
@end
