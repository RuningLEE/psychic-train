//
//  CompanyAllCommentViewController.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/3.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "StoreComment.h"
#import "CompanyCommentCell.h"
#import "MSSBrowseDefine.h"
#import "GetMallDpCommentListRequest.h"
#import "FreeFunctionViewController.h"
#import "CompanyAllCommentViewController.h"

#import "Growing.h"
@interface CompanyAllCommentViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrStoreCommentData; // 评论
@property (nonatomic) NSInteger pageComment;
@end

@implementation CompanyAllCommentViewController
-(void)viewWillAppear:(BOOL)animated{
    self.growingAttributesPageName=@"dpDetail_ios";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([_showType integerValue] != 0) {
       
        // 下拉刷新
        MJRefreshNormalHeader *headerSelected = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getStoredData)];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        headerSelected.automaticallyChangeAlpha = YES;
        // 隐藏时间
        headerSelected.lastUpdatedTimeLabel.hidden = YES;
        // 马上进入刷新状态
        [headerSelected beginRefreshing];
        // 设置header
        _tableView.mj_header = headerSelected;
        
        //加载更多
        __weak typeof(self) weakSelf = self;
        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [weakSelf getBuildingStoreCommentData:weakSelf.pageComment + 1];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getStoredData {
     [self getBuildingStoreCommentData:0];
}

//  返回
- (IBAction)btnCilckBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 免费预约
- (IBAction)btnClickFreeAppiont:(id)sender {
    FreeFunctionViewController *view = [[FreeFunctionViewController alloc] initWithNibName:@"FreeFunctionViewController" bundle:nil];
    view.freeType = @"3";
    view.storeId = _storeId;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([_showType integerValue] == 0) {
        float commentHeight = 100;
        if (_storeComment.rrContent != nil) {
            CGSize contentSize = [_storeComment.rrContent boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT)
                                                                       options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                    attributes:@{NSFontAttributeName:
                                                                                     [UIFont systemFontOfSize:15]}
                                                                       context:nil].size;
            if (_storeComment.imgs.count == 0) {
                commentHeight = 88 + contentSize.height;
            }else{
                commentHeight = 177 + contentSize.height;
            }
        }
        return commentHeight;
    }else{
        StoreComment *storeComment = _arrStoreCommentData[indexPath.row];
        float commentHeight = 100;
        if (storeComment.rrContent != nil) {
            CGSize contentSize = [storeComment.rrContent boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT)
                                                                       options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                    attributes:@{NSFontAttributeName:
                                                                                     [UIFont systemFontOfSize:15]}
                                                                       context:nil].size;
            if (storeComment.imgs.count == 0) {
                commentHeight = 88 + contentSize.height;
            }else{
                commentHeight = 177 + contentSize.height;
            }
        }
        return commentHeight;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_showType intValue] == 0) {
        return 1;
    }else{
        return _arrStoreCommentData.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * companyCommentCell = @"CompanyCommentCell";
    CompanyCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:companyCommentCell];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"CompanyCommentCell" bundle:nil] forCellReuseIdentifier:companyCommentCell];
        cell = [tableView dequeueReusableCellWithIdentifier:companyCommentCell];
    }
    
    
    cell.imageView1.userInteractionEnabled = YES;
    cell.imageView1.tag = indexPath.row;
    UITapGestureRecognizer* enlarge_tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickImageViewToEnlargeWithImageViewOne:)];
    [cell.imageView1 addGestureRecognizer:enlarge_tap1];
    
    
    cell.imageView2.userInteractionEnabled = YES;
    cell.imageView2.tag = indexPath.row;
    UITapGestureRecognizer* enlarge_tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickImageViewToEnlargeWithImageViewTwo:)];
    [cell.imageView2 addGestureRecognizer:enlarge_tap2];
    
    
    cell.imageView3.userInteractionEnabled = YES;
    cell.imageView3.tag = indexPath.row;
    UITapGestureRecognizer* enlarge_tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickImageViewToEnlargeWithImageViewThree:)];
    [cell.imageView3 addGestureRecognizer:enlarge_tap3];
    
    NSArray *imgs = _storeComment.imgs;
    if (imgs.count == 0) {
        [cell.imageView1 removeGestureRecognizer:enlarge_tap1];
        [cell.imageView2 removeGestureRecognizer:enlarge_tap2];
        [cell.imageView3 removeGestureRecognizer:enlarge_tap3];
    }else if (imgs.count == 1){
        [cell.imageView2 removeGestureRecognizer:enlarge_tap2];
        [cell.imageView3 removeGestureRecognizer:enlarge_tap3];
    }else if (imgs.count == 2){
        [cell.imageView3 removeGestureRecognizer:enlarge_tap3];
    }
    cell.viewTopLine.hidden = NO;
    if (indexPath.row == 0) {
        cell.viewTopLine.hidden = YES;
    }
    
    if ([_showType integerValue] == 0) {
        [cell loadData:_storeComment];
    }else{
        StoreComment *storeComment = _arrStoreCommentData[indexPath.row];
        [cell loadData:storeComment];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

//放大图片
- (void)ClickImageViewToEnlargeWithImageViewOne:(UITapGestureRecognizer*)Tap{
    
    NSArray *imgs = _storeComment.imgs;
    
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    int i = 0;
    for(i = 0;i < imgs.count && i< 3;i++)
    {
        UIImageView *imageView = [self.view viewWithTag:i + 100];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = imgs[i];// 加载网络图片大图地址
        browseItem.smallImageView = imageView;// 小图
        [browseItemArray addObject:browseItem];
    }
    
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:0];
    bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
    [bvc showBrowseViewController];
}

//放大图片
- (void)ClickImageViewToEnlargeWithImageViewTwo:(UITapGestureRecognizer*)Tap{

    NSArray *imgs = _storeComment.imgs;
    
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    int i = 0;
    for(i = 0;i < imgs.count && i< 3;i++)
    {
        UIImageView *imageView = [self.view viewWithTag:i + 100];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = imgs[i];// 加载网络图片大图地址
        browseItem.smallImageView = imageView;// 小图
        [browseItemArray addObject:browseItem];
    }
    
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:1];
    bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
    [bvc showBrowseViewController];
}

//放大图片
- (void)ClickImageViewToEnlargeWithImageViewThree:(UITapGestureRecognizer*)Tap{

    NSArray *imgs = _storeComment.imgs;
    
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    int i = 0;
    for(i = 0;i < imgs.count && i< 3;i++)
    {
        UIImageView *imageView = [self.view viewWithTag:i + 100];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = imgs[i];// 加载网络图片大图地址
        browseItem.smallImageView = imageView;// 小图
        [browseItemArray addObject:browseItem];
    }
    
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:2];
    bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
    [bvc showBrowseViewController];
}


// 用户评论
- (void)getBuildingStoreCommentData:(NSInteger)page {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_storeId forKey:@"store_id"];
   // [parameters setValue:@"44017" forKey:@"store_id"];
    [parameters setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setValue:@10 forKey:@"size"];
  
    __weak typeof(self) weakSelf = self;
    [GetMallDpCommentListRequest requestWithParameters:parameters
                                         withCacheType:DataCacheManagerCacheTypeMemory
                                     withIndicatorView:nil
                                     withCancelSubject:[GetMallDpCommentListRequest getDefaultRequstName]
                                        onRequestStart:nil
                                     onRequestFinished:^(CIWBaseDataRequest *request) {
                                         
                                         if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                                             weakSelf.pageComment = page;
                                             
                                             if (weakSelf.pageComment == 0) {
                                                 weakSelf.arrStoreCommentData = [NSMutableArray array];
                                             }
                                             //条数
                                             NSInteger total = [[request.resultDic objectForKey:@"total"] integerValue];
                                             
                                             NSArray *array = [request.resultDic objectForKey:@"storeComment"];
                                             if (array.count > 0) {
                                                 [weakSelf.arrStoreCommentData addObjectsFromArray:array];
                                             }
                                             
                                             [weakSelf.tableView reloadData];
                                             
                                             if (weakSelf.arrStoreCommentData.count >= total) {
                                                 [_tableView.mj_footer endRefreshingWithNoMoreData];
                                             } else {
                                                 [_tableView.mj_footer resetNoMoreData];
                                             }
                                         }
                                         if ([_tableView.mj_footer isRefreshing]) {
                                             [_tableView.mj_footer endRefreshing];
                                         }
                         
                                         [_tableView.mj_header endRefreshing];
                                         
                                     }
                                     onRequestCanceled:^(CIWBaseDataRequest *request) {
                                         if ([_tableView.mj_footer isRefreshing]) {
                                             [_tableView.mj_footer endRefreshing];
                                         }
                                         [_tableView.mj_header endRefreshing];
                        
                                     }
                                       onRequestFailed:^(CIWBaseDataRequest *request) {
                                           if ([_tableView.mj_footer isRefreshing]) {
                                               [_tableView.mj_footer endRefreshing];
                                           }
                                           [_tableView.mj_header endRefreshing];
                                       }];
}


@end
