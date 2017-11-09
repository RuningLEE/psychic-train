//
//  MyOrderViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderTableViewCell.h"
#import "MyOrderDetailViewController.h"
#import "EvlauateOrderViewController.h"
#import "OrderUploadViewController.h"
#import "GetOrderListRequest.h"
#import "OrderModel.h"
#import "BackCrashViewController.h"
@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *viewBlank;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrOrder;
@property (assign, nonatomic) int page;
@property (assign, nonatomic,getter=isRefreshing) BOOL refreshing;
@property(nonatomic,strong)NSMutableArray *is_DpArray;
@property(nonatomic,strong)NSString *buttonTitle;//fanxian
@property(nonatomic,strong)NSString *dpTitle;//dianping
@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _is_DpArray=[[NSMutableArray alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGB(246, 246, 246);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"MyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellOrder"];
    _tableView.rowHeight = 200;
    _page = 0;

    [self addRefreshing];
    
    [_tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy init
- (NSMutableArray *)arrOrder{
    if (_arrOrder == nil) {
        _arrOrder = [NSMutableArray array];
    }
    return _arrOrder;
}

//添加刷新
- (void)addRefreshing{
    //添加下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        _refreshing = YES;
        [self getOrderListRequest];
    }];
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    //添加上拉刷新
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _refreshing = NO;
        [self getOrderListRequest];
    }];
}

#pragma mark - Request
- (void)getOrderListRequest{
//"city_id": "110900","uid": "12765294","page":"0","size":"20","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
    /*
     "city_id": "110900","access_token": "NgDXJv3Ua8Wt9899qXHFc28OgCbp1GvFrffPYqlmxGV8AI5t7Z88gr7/yXihf8d9ehGUfuTQZYSk9cx+rn6XLX8Sk3r/xzPfq/zAL6p/w310EZcsr8E=","page":"0","size":"20","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_page],@"page",PAGESIZE,@"size", nil];
    [GetOrderListRequest requestWithParameters:param withCacheType:0 withIndicatorView:nil withCancelSubject:[GetOrderListRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([RESPONSE_OK isEqualToString:request.errCode]) {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            NSLog(@"total==%@",request.resultDic);
            _is_DpArray=request.resultDic[@"data"][@"data"];
            //_is_Dp=request.resultDic
            if ([[request.resultDic objectForKey:@"arrOrder"] count] == 0) {
                _viewBlank.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-50);
                [self.view addSubview:_viewBlank];
            } else {
                [_viewBlank removeFromSuperview];
            }
            
            if ([[request.resultDic objectForKey:@"arrOrder"] count] < 20) {
                _tableView.mj_footer.hidden = YES;
            } else {
                _tableView.mj_footer.hidden = NO;
                _page++;
            }
            if ([weakSelf isRefreshing] == YES) {//下拉
                [weakSelf.arrOrder removeAllObjects];
                weakSelf.arrOrder = [NSMutableArray arrayWithArray:[request.resultDic objectForKey:@"arrOrder"]];
                [weakSelf.tableView reloadData];
            }else{//上拉
                [weakSelf.arrOrder addObjectsFromArray:[NSMutableArray arrayWithArray:[request.resultDic objectForKey:@"arrOrder"]]];
                [weakSelf.tableView reloadData];
            }
        } else {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrOrder.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    OrderModel *orderModel = (OrderModel *)[self.arrOrder objectAtIndex:indexPath.row];
    MyOrderTableViewCell *cellOrder = [tableView dequeueReusableCellWithIdentifier:@"cellOrder"];
    cellOrder.buttonEvaluate.tag = indexPath.row;
    [cellOrder.buttonEvaluate addTarget:self action:@selector(evaluateActionWith:) forControlEvents:UIControlEventTouchUpInside];
    if([[_is_DpArray[indexPath.row][@"is_dp"] stringValue]  isEqualToString:@"1"]){
        [cellOrder.buttonEvaluate setTitle:@"修改点评" forState: UIControlStateNormal];
    }else{
        [cellOrder.buttonEvaluate setTitle:@"去点评" forState: UIControlStateNormal];
    }
    _dpTitle=cellOrder.buttonEvaluate.titleLabel.text;
    cellOrder.fanXian.tag=indexPath.row+100;
    [cellOrder.fanXian addTarget:self action:@selector(BackCrash:) forControlEvents:UIControlEventTouchUpInside];
    if([orderModel.orderStatus isEqualToString:@"2"]){
        _buttonTitle=cellOrder.fanXian.titleLabel.text;
;
    }else{
        _buttonTitle=@"";
    }
    
    //setter方法赋值
    cellOrder.orderModel = orderModel;
    return cellOrder;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"*****==%@",self.arrOrder);
    OrderModel *orderModel = (OrderModel *)[self.arrOrder objectAtIndex:indexPath.row];
    MyOrderDetailViewController *orderDetail = [[MyOrderDetailViewController alloc]init];
    orderDetail.orderId = orderModel.orderId;
    orderDetail.buttonTitle=_buttonTitle;
    orderDetail.dpTitle=_dpTitle;
    orderDetail.remarkId=_is_DpArray[indexPath.row][@"remark_id"];
    [self.navigationController pushViewController:orderDetail animated:YES];
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)uploadOrder:(id)sender {
    NSLog(@"%@",DATA_ENV.userInfo.user.huiyuanjieOrder);
    if ([DATA_ENV.userInfo.user.huiyuanjieOrder isEqualToString:@"1"]) {
        OrderUploadViewController *uploadController = [[OrderUploadViewController alloc]init];
        [self.navigationController pushViewController:uploadController animated:YES];
    } else {
        [self.view makeToast:@"不在会员节上传订单时间范围内" duration:1 position:CSToastPositionCenter];
        return;
    }
}

- (void)evaluateActionWith:(UIButton *)sender{
    NSInteger index = sender.tag;
    //根据点击的下标找到对应的元素进行跳转
    OrderModel *orderModel = (OrderModel *)[self.arrOrder objectAtIndex:index];
    EvlauateOrderViewController *evlauateController = [[EvlauateOrderViewController alloc]init];
    evlauateController.orderModel = orderModel;
    if([sender.titleLabel.text isEqualToString:@"去点评"]){
        evlauateController.type=@"1";
    }else if ([sender.titleLabel.text isEqualToString:@"修改点评"]){
        evlauateController.type=@"2";
        NSLog(@"888==%@",_is_DpArray[index][@"remark_id"]);
        evlauateController.remarkID=[NSString stringWithFormat:@"%@",_is_DpArray[index][@"remark_id"] ];
    }

    [self.navigationController pushViewController:evlauateController animated:YES];
}
-(void)BackCrash:(UIButton *)sender{
    NSInteger index = sender.tag-100;
    //根据点击的下标找到对应的元素进行跳转
    OrderModel *orderModel = (OrderModel *)[self.arrOrder objectAtIndex:index];
    BackCrashViewController *evlauateController = [[BackCrashViewController alloc]init];
    //evlauateController.orderModel = orderModel;
    [self.navigationController pushViewController:evlauateController animated:YES];

}
@end
