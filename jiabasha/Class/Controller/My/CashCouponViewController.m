//
//  CashCouponViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/6.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CashCouponViewController.h"
#import "CashCouponTableViewCell.h"
#import "CashCouponDetailViewController.h"
#import "Masonry.h"
#import "GetCouponListRequest.h"
#import "CouponModel.h"

@interface CashCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labelDidNotUse;
@property (weak, nonatomic) IBOutlet UILabel *labelDidUse;
@property (weak, nonatomic) IBOutlet UILabel *labelPast;
@property (weak, nonatomic) IBOutlet UIView *viewUnderline;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) int page;
@property (strong, nonatomic) NSString* invalid;//1有效,0已使用,2过期
@property (assign, nonatomic,getter=isrefreshing) BOOL refreshing;
@property (strong, nonatomic) NSMutableArray *arrCoupon;
@end

@implementation CashCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //布局子控件
    [self setUp];
    //初始化手势
    [self initGestureRecognizer];

    [self addRefreshing];
    //请求接口
    [_tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CashCouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellCash"];
    _tableView.backgroundColor = RGB(244, 244, 244);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 100;
    _labelDidNotUse.tag = 1;
    _labelDidUse.tag = 2;
    _labelPast.tag = 3;
    _invalid = @"1";
}

- (void)initGestureRecognizer{
    [_labelDidNotUse addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClickWithGesture:)]];
    [_labelDidUse addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClickWithGesture:)]];
    [_labelPast addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClickWithGesture:)]];
}

#pragma mark - lazyinit
- (NSMutableArray *)arrCoupon
{
    if (_arrCoupon == nil) {
        _arrCoupon = [NSMutableArray array];
    }
    return _arrCoupon;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加刷新
- (void)addRefreshing{
    //添加下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        _refreshing = YES;
        [self getCouponListRequest];
    }];
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    //添加上拉刷新
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _refreshing = NO;
        [self getCouponListRequest];
    }];
}

#pragma mark - Request
- (void)getCouponListRequest{
    /*
     "uid": "12743702","invalid":"1","page":"0","size":"20","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
    
    /*
     "used_count": 0, //已使用数量
     "init_count": 1, //未使用数量
     "overdue_count": 2, //已过期数量
     */
    __weak typeof(self) weakSelf = self;
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:DATA_ENV.userInfo.user.uid,@"uid",_invalid,@"invalid",PAGESIZE,@"size",[NSString stringWithFormat:@"%d",_page],@"page", nil];
    /*
     "access_token": "NgDXJv3Ua8Wt9894qn/EeW8OgCbp1GvFrffPYqlmxGV8AI5t7Z88gr7/yXihfsN8exeVf+TQYoGl9s5/oHvAc3lGlX+rlWKG/qDMLaApwC15FZF6/ZU=","cash_code_id": "703633","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_invalid,@"invalid",PAGESIZE,@"size",[NSString stringWithFormat:@"%d",_page],@"page",DATA_ENV.userInfo.user.uid,@"uid",nil];
    [GetCouponListRequest requestWithParameters:param withIsCacheData:NO withIndicatorView:nil withCancelSubject:[GetCouponListRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([RESPONSE_OK isEqualToString:request.errCode]) {
            //取总数量
            _labelDidNotUse.text = [[request.resultDic objectForKey:@"initCount"] description];
            _labelPast.text = [[request.resultDic objectForKey:@"overdueCount"] description];
            _labelDidUse.text = [[request.resultDic objectForKey:@"usedCount"] description];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            
            if ([[request.resultDic objectForKey:@"arrCoupon"] count] < 20) {
                _tableView.mj_footer.hidden = YES;
            } else {
                _tableView.mj_footer.hidden = NO;
                _page++;
            }
            if ([weakSelf isrefreshing] == YES) {//下拉
                [weakSelf.arrCoupon removeAllObjects];
                weakSelf.arrCoupon = [NSMutableArray arrayWithArray:[request.resultDic objectForKey:@"arrCoupon"]];
                [weakSelf.tableView reloadData];
            }else{//上拉
                [weakSelf.arrCoupon addObjectsFromArray:[NSMutableArray arrayWithArray:[request.resultDic objectForKey:@"arrCoupon"]]];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrCoupon.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponModel *couponModel = (CouponModel *)[self.arrCoupon objectAtIndex:indexPath.row];
    CashCouponTableViewCell *cellCash = [tableView dequeueReusableCellWithIdentifier:@"cellCash"];
    //cell值设定
    [cellCash initWithCouponModel:couponModel];
    return cellCash;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponModel *couponModel = (CouponModel *)[self.arrCoupon objectAtIndex:indexPath.row];
    CashCouponDetailViewController *cashCouponDetail = [[CashCouponDetailViewController alloc]init];
    cashCouponDetail.cashCodeId = couponModel.cashCodeId;
    [self.navigationController pushViewController:cashCouponDetail animated:YES];
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - labelClick
- (void)labelClickWithGesture:(UITapGestureRecognizer *)tap{
    switch (tap.view.tag) {
        case 1:
        {
            [_viewUnderline mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_labelDidNotUse.mas_centerX);
            }];
            _labelDidNotUse.textColor = RGB(96, 25, 134);
            _labelPast.textColor = RGB(51, 51, 51);
            _labelDidUse.textColor = RGB(51, 51, 51);
            [self.view layoutIfNeeded];
            _invalid = @"1";
            [_tableView.mj_header beginRefreshing];
        }
            break;
        case 2:
        {
            [_viewUnderline mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_labelDidUse.mas_centerX);
            }];
            _labelDidNotUse.textColor = RGB(51, 51, 51);
            _labelPast.textColor = RGB(51, 51, 51);
            _labelDidUse.textColor = RGB(96, 25, 134);
            [self.view layoutIfNeeded];
            _invalid = @"2";
            [_tableView.mj_header beginRefreshing];
        }
            break;
        case 3:
        {
            [_viewUnderline mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_labelPast.mas_centerX);
            }];
            _labelDidNotUse.textColor = RGB(51, 51, 51);
            _labelPast.textColor = RGB(96, 25, 134);
            _labelDidUse.textColor = RGB(51, 51, 51);
            [self.view layoutIfNeeded];
            _invalid = @"0";
            [_tableView.mj_header beginRefreshing];
        }
            break;

        default:
            break;
    }
}

@end
