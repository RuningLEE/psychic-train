//
//  ShopSubscribeViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ShopSubscribeViewController.h"
#import "ShopSubscribeTableViewCell.h"
#import "ShopSubscribeDetailViewController.h"
#import "GetStoreSubscribeListRequest.h"
#import "SubscribeStore.h"
#import "CommonUnSubscribeViewController.h"
#import "CommonWebViewController.h"
#import "WebViewController.h"

@interface ShopSubscribeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrShop;
@property (assign, nonatomic, getter=isRefreshing) BOOL refreshing;
@property (assign, nonatomic) int page;
@property (strong, nonatomic) CommonUnSubscribeViewController *unSubscribeViewController;
@end

@implementation ShopSubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGB(246, 246, 246);
    [_tableView registerNib:[UINib nibWithNibName:@"ShopSubscribeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellSub"];
    _tableView.rowHeight = 80;
    [self addRefreshing];
    [_tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseForNotificationCenter:) name:@"responseForStoreSubscribe" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy init
- (NSMutableArray *)arrShop{
    if (_arrShop == nil) {
        _arrShop = [NSMutableArray array];
    }
    return _arrShop;
}

- (void)setUnSubscribeView{
    _unSubscribeViewController = [[CommonUnSubscribeViewController alloc]init];
    _unSubscribeViewController.superType = @"shop";
    _unSubscribeViewController.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    [self.view addSubview:_unSubscribeViewController.view];
}

//添加刷新
- (void)addRefreshing{
        //添加下拉刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 0;
            _refreshing = YES;
            [self getShopSubcribeListRequest];
        }];
        _tableView.mj_header.automaticallyChangeAlpha = YES;
    
        //添加上拉刷新
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _refreshing = NO;
            [self getShopSubcribeListRequest];
        }];
}

#pragma mark - Request
- (void)getShopSubcribeListRequest{
    /*
     "city_id": "110900","uid": "12859823","page":"0","size":"20","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
    __weak typeof(self)weakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:PAGESIZE,@"size",[NSString stringWithFormat:@"%d",_page],@"page", nil];
    [GetStoreSubscribeListRequest requestWithParameters:param withCacheType:DataCacheManagerCacheTypeMemory withIndicatorView:nil withCancelSubject:[GetStoreSubscribeListRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([RESPONSE_OK isEqualToString:request.errCode]) {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            if ([[request.resultDic objectForKey:@"arrStore"] count] == 0) {
                [self setUnSubscribeView];
            } else {
                [_unSubscribeViewController.view removeFromSuperview];
            }
            
            if ([[request.resultDic objectForKey:@"arrStore"] count] < 20) {
                _tableView.mj_footer.hidden = YES;
            } else {
                _tableView.mj_footer.hidden = NO;
                _page++;
            }
            if ([self isRefreshing] == YES) {//下拉
                [weakSelf.arrShop removeAllObjects];
                weakSelf.arrShop = [NSMutableArray arrayWithArray:[request.resultDic objectForKey:@"arrStore"]];
                [self.tableView reloadData];
            }else{//上拉
                [weakSelf.arrShop addObjectsFromArray:[NSMutableArray arrayWithArray:[request.resultDic objectForKey:@"arrStore"]]];
                [self.tableView reloadData];
            }
        } else {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrShop.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubscribeStore *storeModel = (SubscribeStore *)[self.arrShop objectAtIndex:indexPath.row];
    ShopSubscribeTableViewCell *cellShop = [tableView dequeueReusableCellWithIdentifier:@"cellSub"];
    cellShop.selectionStyle = UITableViewCellSelectionStyleNone;
    [cellShop initWithSubstoreModel:storeModel];
    return cellShop;
}

#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubscribeStore *storeModel = (SubscribeStore *)[self.arrShop objectAtIndex:indexPath.row];
    ShopSubscribeDetailViewController *shopDetail = [[ShopSubscribeDetailViewController alloc]init];
    shopDetail.reserveId = storeModel.reserveId;
    [self.navigationController pushViewController:shopDetail animated:YES];
}

#pragma mark - notification method

- (void)responseForNotificationCenter:(NSNotification *)notification{
    NSDictionary *modelDic = [notification userInfo];
    WebViewController *webController = [[WebViewController alloc]init];
    webController.urlString = [modelDic objectForKey:@"url"];
    [self.navigationController pushViewController:webController animated:YES];
}

@end
