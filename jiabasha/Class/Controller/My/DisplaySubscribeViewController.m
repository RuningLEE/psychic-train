//
//  DisplaySubscribeViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "DisplaySubscribeViewController.h"
#import "DisplayRemindTableViewCell.h"
#import "DisplaySubscribeDetailViewController.h"
#import "DisplaySubscribeTableViewCell.h"
#import "GetDisplaySubscribeListRequest.h"
#import "DisplaySubscribeModel.h"
#import "CommonUnSubscribeViewController.h"
#import "CommonWebViewController.h"
#import "WebViewController.h"

@interface DisplaySubscribeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrDisplay;
@property (assign, nonatomic, getter=isRefreshing) BOOL refreshing;
@property (assign, nonatomic) int page;
@property (strong, nonatomic) CommonUnSubscribeViewController *unSubscribeViewController;
@end

@implementation DisplaySubscribeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addRefreshing];
    [_tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGB(246, 246, 246);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"DisplayRemindTableViewCell" bundle:nil] forCellReuseIdentifier:@"CellRemind"];
    [_tableView registerNib:[UINib nibWithNibName:@"DisplaySubscribeTableViewCell" bundle:nil] forCellReuseIdentifier:@"CellDisplay"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseForNotificationCenter:) name:@"responseForDicplaySubscribe" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)arrDisplay{
    if (_arrDisplay == nil) {
        _arrDisplay = [NSMutableArray array];
    }
        return _arrDisplay;
}

//添加刷新
- (void)addRefreshing{
    //添加下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        _refreshing = YES;
        [self getDisplaySubscribeListRequest];
    }];
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    //添加上拉刷新
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _refreshing = NO;
        [self getDisplaySubscribeListRequest];
    }];
}

- (void)setUnSubscribeView{
    _unSubscribeViewController = [[CommonUnSubscribeViewController alloc]init];
    _unSubscribeViewController.superType = @"display";
    _unSubscribeViewController.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    [self.view addSubview:_unSubscribeViewController.view];
}

- (void)getDisplaySubscribeListRequest{
    /*
     "uid": "12859823","page":"0","size":"20","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"}
     */
    __weak typeof(self)weakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_page],@"page",PAGESIZE,@"size", nil];
    [GetDisplaySubscribeListRequest requestWithParameters:param withCacheType:DataCacheManagerCacheTypeMemory withIndicatorView:nil
 withCancelSubject:[GetDisplaySubscribeListRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([RESPONSE_OK isEqualToString:request.errCode]) {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            if ([[request.resultDic objectForKey:@"arrDisModel"] count] == 0) {
                [self setUnSubscribeView];
            } else {
                [_unSubscribeViewController.view removeFromSuperview];
            }
            
            if ([[request.resultDic objectForKey:@"arrDisModel"] count] < 20) {
                _tableView.mj_footer.hidden = YES;
            } else {
                _tableView.mj_footer.hidden = NO;
                _page++;
            }
            if ([weakSelf isRefreshing] == YES) {//下拉
                [weakSelf.arrDisplay removeAllObjects];
                weakSelf.arrDisplay = [NSMutableArray arrayWithArray:[request.resultDic objectForKey:@"arrDisModel"]];
                [weakSelf.tableView reloadData];
            }else{//上拉
                [weakSelf.arrDisplay addObjectsFromArray:[NSMutableArray arrayWithArray:[request.resultDic objectForKey:@"arrDisModel"]]];
                [weakSelf.tableView reloadData];
            }
        } else {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.arrDisplay.count == 0) {
        return 0;
    } else {
        return self.arrDisplay.count+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DisplaySubscribeModel *displayModel;
    if (indexPath.row == 0) {
        displayModel = (DisplaySubscribeModel *)[self.arrDisplay objectAtIndex:indexPath.row];
    } else {
        displayModel = (DisplaySubscribeModel *)[self.arrDisplay objectAtIndex:indexPath.row-1];
    }
    if (indexPath.row == 0) {
        DisplayRemindTableViewCell *cellRemind = [tableView dequeueReusableCellWithIdentifier:@"CellRemind"];
        cellRemind.selectionStyle = UITableViewCellSelectionStyleNone;
        cellRemind.labelTitle.text = displayModel.expo.expoName;
        cellRemind.userInteractionEnabled = NO;
        return cellRemind;
    } else {
        DisplaySubscribeTableViewCell *cellDisplay = [tableView dequeueReusableCellWithIdentifier:@"CellDisplay"];
        cellDisplay.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row%3 == 1) {
            cellDisplay.viewLeftMark.backgroundColor = RGB(83, 203, 248);
        } else if (indexPath.row%3 == 2){
            cellDisplay.viewLeftMark.backgroundColor = RGB(254, 104, 89);
        } else if (indexPath.row%3 == 0){
            cellDisplay.viewLeftMark.backgroundColor = RGB(206, 109, 255);
        }
        [cellDisplay.imageviewCover sd_setImageWithURL:[NSURL URLWithString:displayModel.store.logo] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
        cellDisplay.labelTitle.text = displayModel.store.storeName;
        if ([CommonUtil isEmpty:displayModel.expo.expoStartDate]) {
            cellDisplay.labelSubtitle.text = @"";
        } else {
            cellDisplay.labelSubtitle.text = [NSString stringWithFormat:@"展会时间：%@",displayModel.expo.expoStartDate];
        }
        
        return cellDisplay;
    }
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    }else{
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DisplaySubscribeModel *displayModel = (DisplaySubscribeModel *)[self.arrDisplay objectAtIndex:indexPath.row-1];
    DisplaySubscribeDetailViewController *displayDetail = [[DisplaySubscribeDetailViewController alloc]init];
    displayDetail.orderId = displayModel.reserveId;
    [self.navigationController pushViewController:displayDetail animated:YES];
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)responseForNotificationCenter:(NSNotification *)notification{
    NSDictionary *modelDic = [notification userInfo];
    WebViewController *webController = [[WebViewController alloc]init];
    webController.urlString = [modelDic objectForKey:@"url"];
    [self.navigationController pushViewController:webController animated:YES];
}

@end
