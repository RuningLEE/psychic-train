//
//  MyClusterViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "MyClusterViewController.h"
#import "MyClusterTableViewCell.h"
#import "Masonry.h"
#import "MyClusterCollectionViewCell.h"
#import "HomeHeaderViewnew.h"
#import "ShareView.h"
#import "GetMyClusterList.h"
#import "SearchProductRequest.h"
#import "ShareViewController.h"
#import "GroupProductDetailViewController.h"
#import "RenovationShopDetialViewController.h"
#import "Product.h"

@interface MyClusterViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UIView *viewNoCluster;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewAll;
@property (weak, nonatomic) IBOutlet UIView *viewOver;
@property (weak, nonatomic) IBOutlet UIView *viewSuccess;
@property (weak, nonatomic) IBOutlet UIView *viewFailure;
@property (weak, nonatomic) IBOutlet UIView *viewWait;
@property (strong, nonatomic) NSMutableArray *arrCluster;
@property (weak, nonatomic) IBOutlet UIView *viewUnderLine;
@property (weak, nonatomic) IBOutlet UILabel *labelAll;
@property (weak, nonatomic) IBOutlet UILabel *labelOver;
@property (weak, nonatomic) IBOutlet UILabel *labelSuccess;
@property (weak, nonatomic) IBOutlet UILabel *labelFailure;
@property (weak, nonatomic) IBOutlet UILabel *labelWait;
@property (strong, nonatomic) NSMutableArray *arrRecomandProduct;
@property (strong, nonatomic) IBOutlet UIView *viewCollectionHeader;
@property (strong, nonatomic) ShareView *viewShare;
@property (assign, nonatomic) int page;
@property (assign, nonatomic, getter=isRefreshing) BOOL refreshing;
@end

@implementation MyClusterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    [self addRefreshing];
    [_tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    //设定tableview
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 202;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"MyClusterTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellCluster"];
    _tableView.backgroundColor = RGB(244, 244, 244);
}

//添加刷新
- (void)addRefreshing{
    //添加下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        _refreshing = YES;
        [self getClusterListRequest];
    }];
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    //添加上拉刷新
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _refreshing = NO;
        [self getClusterListRequest];
    }];
}

//在没有拼团信息的时候显示collcection推荐
- (void)addcollectionView{
    [self getRecommendReuqest];
    //设定collectionview
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"MyClusterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectioncellCluster"];
    [_collectionView registerClass:[HomeHeaderViewnew class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    __weak typeof(self)Weakself = self;
    
    [self.view addSubview:_viewNoCluster];
    [_viewNoCluster mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Weakself.tableView.mas_top);
        make.left.mas_equalTo(Weakself.tableView.mas_left);
        make.right.mas_equalTo(Weakself.tableView.mas_right);
        make.bottom.mas_equalTo(Weakself.tableView.mas_bottom);
    }];
}

//移除推荐视图
- (void)removeCollectionView{
    [_viewNoCluster removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyinit
- (NSMutableArray *)arrCluster
{
    if (_arrCluster == nil) {
        _arrCluster = [[NSMutableArray alloc]init];
    }
    return _arrCluster;
}

- (NSMutableArray *)arrRecomandProduct
{
    if (_arrRecomandProduct == nil) {
        _arrRecomandProduct = [NSMutableArray array];
    }
    return _arrRecomandProduct;
}

#pragma mark - Request

//获取拼团列表数据
- (void)getClusterListRequest{
    //params - {"city_id": "110900","uid":"12724813","page":"0","size":"20","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"}
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",_page],@"page",PAGESIZE,@"size", nil];
    [GetMyClusterList requestWithParameters:param withCacheType:0 withIndicatorView:nil withCancelSubject:[GetMyClusterList getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([RESPONSE_OK isEqualToString:request.errCode]) {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            if ([[request.resultDic objectForKey:@"arrClusterModel"] count] == 0) {
                [self addcollectionView];
            } else {
                [self removeCollectionView];
            }
            
            if ([[request.resultDic objectForKey:@"arrClusterModel"] count] < 20) {
                _tableView.mj_footer.hidden = YES;
            } else {
                _tableView.mj_footer.hidden = NO;
                _page++;
            }
            if ([weakSelf isRefreshing] == YES) {//下拉
                [weakSelf.arrCluster removeAllObjects];
                weakSelf.arrCluster = [NSMutableArray arrayWithArray:[request.resultDic objectForKey:@"arrClusterModel"]];
                [weakSelf.tableView reloadData];
            }else{//上拉
                [weakSelf.arrCluster addObjectsFromArray:[NSMutableArray arrayWithArray:[request.resultDic objectForKey:@"arrClusterModel"]]];
                [weakSelf.tableView reloadData];
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

//获取推荐商品数据
- (void)getRecommendReuqest{
    /*
     "city_id": "110900","keyword":"","cate_id":"","sort_type":"dp_ascdp_desc","page":"0","size":"20","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"}
     sortType sort_type 排序: dp_ascdp_desc综合排序(默认),appoint_ascappoint_desc 预约最多 ,dp_descdp_asc 点评权重数 price_desc商品最大值降序 price_asc商品最小值升序

     */
    
    NSDictionary *param = @{@"keyword":@"",@"sort_type":@"dp_ascdp_desc",@"page":@"0",@"size":@"4",@"cate_pid":@"2083"};
    [SearchProductRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[SearchProductRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            _arrRecomandProduct = [NSMutableArray arrayWithArray:[request.resultDic objectForKey:@"product"]];
            [_collectionView reloadData];
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
    return self.arrCluster.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyClusterModel *clusterModel = (MyClusterModel *)[_arrCluster objectAtIndex:indexPath.row];
    MyClusterTableViewCell *cellCluster = [tableView dequeueReusableCellWithIdentifier:@"cellCluster"];
    cellCluster.clusterModel = clusterModel;
    cellCluster.buttonJoin.tag = indexPath.row;
    [cellCluster.buttonJoin addTarget:self action:@selector(showSharView:) forControlEvents:UIControlEventTouchUpInside];
    return cellCluster;
}

#pragma makr - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyClusterModel *clusterModel = (MyClusterModel *)[_arrCluster objectAtIndex:indexPath.row];
        GroupProductDetailViewController *viewControler = [[GroupProductDetailViewController alloc] init];
        viewControler.productId = clusterModel.productId;
        [self.navigationController pushViewController:viewControler animated:YES];

}

#pragma mark - CollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.arrRecomandProduct.count > 4) {
        return 4;
    } else {
        return self.arrRecomandProduct.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Product *productModel = (Product *)[self.arrRecomandProduct objectAtIndex:indexPath.row];
    MyClusterCollectionViewCell *cellCluster = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncellCluster" forIndexPath:indexPath];
    [cellCluster setClusterProduct:productModel];
    return cellCluster;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = (kScreenWidth - 26)/2;
    float height = width*258/175;
    return CGSizeMake(width, height);
}

//执行的 headerView 代理  返回 headerView 的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 210);
}

//headerview view
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HomeHeaderViewnew *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableview.backgroundColor = [UIColor blackColor];
        self.viewCollectionHeader.frame = CGRectMake(0, 0, kScreenWidth, 210);
        [reusableview addSubview:self.viewCollectionHeader];
    }
    return reusableview;
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Product *productModel = (Product *)[self.arrRecomandProduct objectAtIndex:indexPath.row];
    if ([productModel.tuaning boolValue] == YES) {
        GroupProductDetailViewController *viewControler = [[GroupProductDetailViewController alloc] init];
        viewControler.productId = productModel.productId;
        [self.navigationController pushViewController:viewControler animated:YES];
    } else {
        RenovationShopDetialViewController *viewControler = [[RenovationShopDetialViewController alloc] init];
        viewControler.productId = productModel.productId;
        [self.navigationController pushViewController:viewControler animated:YES];
    }
}

//定义每个UICollectionView的margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    float width = (kScreenWidth - 26)/2;
    return UIEdgeInsetsMake((kScreenWidth-2*width)/3, (kScreenWidth-2*width)/3, (kScreenWidth-2*width)/3, (kScreenWidth-2*width)/3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  );
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//喊人参团
- (void)showSharView:(UIButton *)button{

//    ShareViewController *viewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
//    //viewController.shareContent = _dictDetail[@"share_content"];
//    
//    UIViewController* controller = self.view.window.rootViewController;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
//        viewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//    }else{
//        controller.modalPresentationStyle = UIModalPresentationCurrentContext;
//    }
//    
//    [controller presentViewController:viewController animated:YES completion:^{
//        viewController.view.superview.backgroundColor = [UIColor clearColor];
//    }];
    MyClusterModel *clusterModel = (MyClusterModel *)[_arrCluster objectAtIndex:button.tag];
    NSString *imageurl = nil;
    if (![CommonUtil isEmpty:clusterModel.productPicUrl]) {
        imageurl = clusterModel.productPicUrl;
    }
    NSString *link = [NSString stringWithFormat:@"http://h5.jiabasha.com/product/%@", clusterModel.productId];
    
    ShareViewController *viewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    viewController.shareContent = @{@"title":clusterModel.productName, @"logo":imageurl, @"link":link};
    
    UIViewController* controller = self.view.window.rootViewController;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        viewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }else{
        controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    [controller presentViewController:viewController animated:YES completion:^{
        viewController.view.superview.backgroundColor = [UIColor clearColor];
    }];

}
@end
