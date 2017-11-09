//
//  CouponViewController.m
//  jiabasha
//
//  Created by guok on 17/1/16.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CouponViewController.h"
#import "HMSegmentedControl.h"
#import "UIColor-Expanded.h"
#import "GetMallCategoryListRequest.h"
#import "GetMallCouponListRequest.h"
#import "CategoryMall.h"
#import "CouponMall.h"
#import "CouponListTableViewCell.h"
#import "CouponDetailViewController.h"

#import "Growing.h"


@interface CouponViewController ()

@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//数据
@property (nonatomic, strong) NSArray *categoryList;
@property (nonatomic, strong) NSMutableArray *couponList;

@property (nonatomic) NSInteger pageIndex;

@end

@implementation CouponViewController
-(void)viewWillAppear:(BOOL)animated{
    self.growingAttributesPageName=@"cashList_ios";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.segmentedControl.sectionTitles = @[@"全部"];
    
    self.segmentedControl.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    
    //self.segmentedPager.segmentedControl.frame = CGRectMake(0, 0, kScreenWidth, 35);
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionIndicatorHeight = 2;
    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithHexString:@"#601986"];
    
    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    
    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 8, 0, 8);

    // 默认状态的字体
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#666666"],
                                                                 NSFontAttributeName : [UIFont systemFontOfSize:15]};
    // 默认状态的字体
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#601986"],
                                                                 NSFontAttributeName : [UIFont systemFontOfSize:15]};
    
    
    self.segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 24);
    
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index){
        [self getMallCouponList:index page:0];
    }];
    
    [self getMallCategoryList];
    
    //注册tableViewCell
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponListTableViewCell" bundle:nil] forCellReuseIdentifier:@"CouponListTableViewCell"];
    
    //加载更多
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
         [weakSelf getMallCouponList:weakSelf.segmentedControl.selectedSegmentIndex page:weakSelf.pageIndex + 1];
    }];

    self.segmentedControl.hidden = YES;
}

#pragma mark - UITableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.couponList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CouponListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponListTableViewCell"];
    
    CouponMall *coupon = [self.couponList objectAtIndex:indexPath.row];
    [cell.imgViewLogo sd_setImageWithURL:[NSURL URLWithString:coupon.imgUrl]];
    cell.labelName.text = coupon.storeName;
    
    cell.labelNum.text = [NSString stringWithFormat:@"已有%@人申请", coupon.receiveCount];
    
//    cell.labelPrice.text = [coupon.levelPrices getDisplayPrices];
    cell.labelPrice.text = coupon.viewMoney;
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CouponMall *coupon = [self.couponList objectAtIndex:indexPath.row];
    CouponDetailViewController *viewController = [[CouponDetailViewController alloc] initWithNibName:@"CouponDetailViewController" bundle:nil];
    viewController.cashCouponId = coupon.cashCouponId;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - action
//返回
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private
//类目
- (void)getMallCategoryList {
    __weak typeof(self) weakSelf = self;
    [GetMallCategoryListRequest requestWithParameters:@{@"level":@"1"}// 参数
                                    withIndicatorView:self.view//网络加载视图加载到某个view
                                       onRequestStart:^(CIWBaseDataRequest *request) {}
                                    onRequestFinished:^(CIWBaseDataRequest *request) {

                                        if([request.errCode isEqualToString:RESPONSE_OK]){
                                            weakSelf.categoryList = [request.resultDic objectForKey:KEY_CATEGORY];
                                        }
                                        [weakSelf showCategoryList];
                                    }
                                    onRequestCanceled:^(CIWBaseDataRequest *request) {
                                        [weakSelf showCategoryList];
                                    }
                                      onRequestFailed:^(CIWBaseDataRequest *request) {
                                          [weakSelf showCategoryList];
                                      }];
}

- (void)showCategoryList {
    self.segmentedControl.hidden = NO;
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.categoryList.count + 1];
    [titles addObject:@"全部"];
    for (CategoryMall *cate in self.categoryList) {
        [titles addObject:cate.cateName];
    }
    self.segmentedControl.sectionTitles = titles;
    [self.segmentedControl setSelectedSegmentIndex:0];
    
    [self getMallCouponList:0 page:0];
}

//取现金券
- (void)getMallCouponList:(NSInteger)index page:(NSInteger)page{
    NSString *category_id = @"2083";
    if (index > 0 && index <= self.categoryList.count) {
        CategoryMall *cate = [self.categoryList objectAtIndex:index - 1];
        category_id = cate.cateId;
    }
//    category_id=@"2065";
    
    NSDictionary *params = @{@"cate_id":category_id, @"page":[NSString stringWithFormat:@"%ld",page], @"size":@"20"};
    
    __weak typeof(self) weakSelf = self;
    [GetMallCouponListRequest requestWithParameters:params
                                  withIndicatorView:self.view//网络加载视图加载到某个view
                                     onRequestStart:^(CIWBaseDataRequest *request) {}
                                  onRequestFinished:^(CIWBaseDataRequest *request) {
                                      
                                      if([request.errCode isEqualToString:RESPONSE_OK]){
                                          weakSelf.pageIndex = page;//[[request.resultDic objectForKey:KEY_COUPON_PAGE] integerValue];
                                          
                                          NSArray *array = [request.resultDic objectForKey:KEY_COUPONLIST];
                                          if (weakSelf.pageIndex == 0) {
                                              weakSelf.couponList = [array mutableCopy];
                                          } else {
                                              [weakSelf.couponList addObjectsFromArray:array];
                                          }
                                          
                                          [weakSelf.tableView reloadData];
                                          
                                          NSInteger total = [[request.resultDic objectForKey:KEY_COUPON_TOTAL] integerValue];
                                          
                                          if (weakSelf.couponList.count >= total) {
                                              [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                          }
                                          
                                      }
                                      
                                      if ([weakSelf.tableView.mj_footer isRefreshing]) {
                                          [weakSelf.tableView.mj_footer endRefreshing];
                                      }
                                  }
                                  onRequestCanceled:^(CIWBaseDataRequest *request) {
                                      if ([weakSelf.tableView.mj_footer isRefreshing]) {
                                          [weakSelf.tableView.mj_footer endRefreshing];
                                      }
                                  }
                                    onRequestFailed:^(CIWBaseDataRequest *request) {
                                        if ([weakSelf.tableView.mj_footer isRefreshing]) {
                                            [weakSelf.tableView.mj_footer endRefreshing];
                                        }
                                    }];
}

@end
