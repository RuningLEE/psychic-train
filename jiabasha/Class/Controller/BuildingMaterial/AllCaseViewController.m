//
//  AllCaseViewController.m
//  jiabasha
//
//  Created by 金伟城 on 16/12/30.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "BuildingExample.h"
#import "AllCaseViewController.h"
#import "WonderfulCaseTableViewCell.h"
#import "FreeFunctionViewController.h"
#import "GetMallExampleListRequest.h"
#import "CaseHomeViewController.h"

#import "UIView+GrowingAttributes.h"
#import "Growing.h"
@interface AllCaseViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewSelectShow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewSelectHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnStyle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewStyle;
@property (weak, nonatomic) IBOutlet UIButton *btnSort;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSort;
@property (weak, nonatomic) IBOutlet UILabel *lableTitle;

@property (nonatomic, strong) NSMutableArray *exampleList; // 精彩案例

@property (strong, nonatomic) NSString *strSelectStyleSort; // 0:风格 1:户型
@property (assign, nonatomic) NSInteger styleCompanyNum;
@property (assign, nonatomic) NSInteger sortCompanyNum;
@property (nonatomic) NSInteger pageExample;
@end

@implementation AllCaseViewController
-(void)viewWillAppear:(BOOL)animated{
    _tableView.growingAttributesUniqueTag=@"albumList_ios";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _exampleList = [NSMutableArray array];
    
    if ([self.isAllCase integerValue] == 0) {
        self.lableTitle.text = @"全部案例";
    }else{
        self.lableTitle.text = _storeName;
    }
    
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
        [weakSelf getBuildingStoreCaseData:weakSelf.pageExample + 1 ];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getStoredData {
    [self getBuildingStoreCaseData:0 ];
    //[_tableViewCompany.mj_header endRefreshing];
}

#pragma mark - 风格选择
- (IBAction)btnStyle:(UIButton *)button {
    self.btnSort.selected = NO;
    self.imageViewSort.image = [UIImage imageNamed:@"展开箭头"];
    if (button.selected) {
        button.selected = NO;
        self.viewSelectShow.hidden = YES;
        self.imageViewStyle.image = [UIImage imageNamed:@"展开箭头"];
    }else{
        self.strSelectStyleSort = @"0";
        [self creatSelectView:1 andSelect:self.styleCompanyNum];
      
        self.imageViewStyle.image = [UIImage imageNamed:@"收回箭头"];
        button.selected = YES;
        self.viewSelectShow.hidden = NO;
        [self moveanimations];
    }
    
}

// 户型选择
- (IBAction)btnSort:(UIButton *)button {
    self.btnStyle.selected = NO;
    self.imageViewStyle.image = [UIImage imageNamed:@"展开箭头"];
    if (button.selected) {
        button.selected = NO;
        self.viewSelectShow.hidden = YES;
        self.imageViewSort.image = [UIImage imageNamed:@"展开箭头"];
    }else{
        self.strSelectStyleSort = @"1";
        [self creatSelectView:1 andSelect:self.sortCompanyNum];
        button.selected = YES;
        self.imageViewSort.image = [UIImage imageNamed:@"收回箭头"];
        self.viewSelectShow.hidden = NO;
        [self moveanimations];
    }
    
}

// 创建选择类型
- (void)creatSelectView:(NSInteger)num andSelect:(NSInteger)selectNum{
    for (id id in self.viewSelectShow.subviews) {
        if ([id isKindOfClass:[UIButton class]]) {
            [id removeFromSuperview];
        }
    }
    
    float btnWide = (kScreenWidth -75)/4;
    for (int a = 0; a<num; a++) {
        float yushu = a/4;
        float beiyushu = a%4;
        UIButton *btnName = [[UIButton alloc] initWithFrame:CGRectMake(15 + (btnWide + 15) *beiyushu , 13 +38 * yushu, btnWide, 25)];
        btnName.backgroundColor = [UIColor clearColor];
        [btnName setTitle:@"默认排序" forState:UIControlStateNormal];
        btnName.layer.borderWidth = 0.5;
        btnName.tag = a;
        btnName.titleLabel.font = [UIFont systemFontOfSize:12];
        btnName.layer.cornerRadius = 3;
        if (a == selectNum) {
            btnName.layer.borderColor = RGB(255, 59, 48).CGColor;
            [btnName setTitleColor:RGB(255, 59, 48) forState:UIControlStateNormal];
        }else{
            btnName.layer.borderColor = RGB(193, 193, 193).CGColor;
            [btnName setTitleColor:RGB(193, 193, 193) forState:UIControlStateNormal];
        }
        
        [btnName addTarget:self action:@selector(selectShow:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewSelectShow addSubview:btnName];
    }
    float yushu = num/4;
    float beiyushu = num%4;
    if (beiyushu == 0) {
        self.viewSelectHeight.constant = 13 + 38 * yushu ;
    }else{
        self.viewSelectHeight.constant = 13 + 38 *( yushu + 1);
    }
    
}

// 选择显示类型
- (void)selectShow:(UIButton *)btn{
    if ([self.strSelectStyleSort integerValue] == 0) {
        self.styleCompanyNum = btn.tag;
        [self creatSelectView:20 andSelect:btn.tag];
    }else  if ([self.strSelectStyleSort integerValue] == 1) {
        self.sortCompanyNum = btn.tag;
        [self creatSelectView:5 andSelect:btn.tag];
    }
    self.viewSelectShow.hidden = YES;
    self.btnSort.selected = NO;
    self.btnStyle.selected = NO;
    self.imageViewSort.image = [UIImage imageNamed:@"展开箭头"];
    self.imageViewStyle.image = [UIImage imageNamed:@"展开箭头"];
}

#pragma mark -动画
- (void)moveanimations{
    float hight = self.viewSelectShow.frame.size.height;
    CGRect frame = self.viewSelectShow.frame;
    frame.size.height = 0;
    self.viewSelectShow.frame = frame;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.viewSelectShow.frame;
        frame.size.height = hight;
        self.viewSelectShow.frame = frame;
    } completion:^(BOOL finished) {
    }];
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
   
    return 253;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return _exampleList.count;
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * wonderfulCaseCell = @"WonderfulCaseTableViewCell";
    WonderfulCaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:wonderfulCaseCell];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"WonderfulCaseTableViewCell" bundle:nil] forCellReuseIdentifier:wonderfulCaseCell];
        cell = [tableView dequeueReusableCellWithIdentifier:wonderfulCaseCell];
    }
    cell.viewCheckAllCase.hidden = YES;
    cell.viewTopLine.hidden = NO;
    if (indexPath.row == 0) {
        cell.viewTopLine.hidden = YES;
    }

    BuildingExample *buildingExample = _exampleList[indexPath.row];
    [cell loadData:buildingExample];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BuildingExample *exampleData = _exampleList[indexPath.row];
    CaseHomeViewController *view = [[CaseHomeViewController alloc] initWithNibName:@"CaseHomeViewController" bundle:nil];
    view.albumId = exampleData.albumId;
    [self.navigationController pushViewController:view animated:YES];
}

// 精彩案例
- (void)getBuildingStoreCaseData:(NSInteger)page {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_storeId forKey:@"store_id"];
    [parameters setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setValue:@10 forKey:@"size"];

    __weak typeof(self) weakSelf = self;
    [GetMallExampleListRequest requestWithParameters:parameters
                                       withCacheType:DataCacheManagerCacheTypeMemory
                                   withIndicatorView:nil
                                   withCancelSubject:[GetMallExampleListRequest getDefaultRequstName]
                                      onRequestStart:nil
                                   onRequestFinished:^(CIWBaseDataRequest *request) {
                                       
                                       
                                       if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                           weakSelf.pageExample = page;
                                           
                                           if (weakSelf.pageExample == 0) {
                                               weakSelf.exampleList = [NSMutableArray array];
                                           }
                                           
                                           NSArray *array = [request.resultDic objectForKey:@"example"];
                                           if (array.count > 0) {
                                               [weakSelf.exampleList addObjectsFromArray:array];
                                           }
                                           
                                           [_tableView reloadData];
                                           
                                           //条数
                                           NSInteger total = [[request.resultDic objectForKey:@"total"] integerValue];
                                         
                                           
                                           if (weakSelf.exampleList.count >= total) {
                                               [_tableView.mj_footer endRefreshingWithNoMoreData];
                                           } else {
                                               [_tableView.mj_footer resetNoMoreData];
                                           }
                                       }
                                       
                                       if ([_tableView.mj_footer isRefreshing]) {
                                           [_tableView.mj_footer endRefreshing];
                                       }
                                       _tableView.tag = 1;
                                       [_tableView.mj_header endRefreshing];
                                   }
                                   onRequestCanceled:^(CIWBaseDataRequest *request) {
                                       if ([_tableView.mj_footer isRefreshing]) {
                                           [_tableView.mj_footer endRefreshing];
                                       }
                                       [_tableView.mj_header endRefreshing];
                                       _tableView.tag = 1;
                                   }
                                     onRequestFailed:^(CIWBaseDataRequest *request) {
                                         if ([_tableView.mj_footer isRefreshing]) {
                                             [_tableView.mj_footer endRefreshing];
                                         }
                                         [_tableView.mj_header endRefreshing];
                                         _tableView.tag = 1;
                                     }];
}


@end
