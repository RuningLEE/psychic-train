//
//  BuildingMaterialViewController.m
//  JiaZhuang
//
//  Created by 金伟城 on 16/12/26.
//  Copyright © 2016年 hzdaoshun. All rights reserved.
//

#import "Store.h"
#import "BuildingExample.h"
#import "CaseTableViewCell.h"
#import "SearchStoreRequest.h"
#import "GetExampleListRequest.h"
#import "CompanyTableViewCell.h"
#import "CaseHomeViewController.h"
#import "CompanySearchViewController.h"
#import "CompanyHomeViewController.h"
#import "BuildingMaterialViewController.h"
#import "AppDelegate.h"

#import "ActivityAlterViewRequest.h"
#import "ActivityAlterView.h"
#import "UIView+GrowingAttributes.h"
#import "Growing.h"
@interface BuildingMaterialViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewCompany;
@property (weak, nonatomic) IBOutlet UITableView *tableViewCase;

@property (weak, nonatomic) IBOutlet UIButton *btnCompany;
@property (weak, nonatomic) IBOutlet UIButton *btnCase;
@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLineLeft;
@property (weak, nonatomic) IBOutlet UIView *viewSelectShow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewSelectHeight;

@property (weak, nonatomic) IBOutlet UIButton *btnStyle;//风格
@property (weak, nonatomic) IBOutlet UIImageView *imageViewStyle;
@property (weak, nonatomic) IBOutlet UIButton *btnSort;//户型
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSort;
@property (weak, nonatomic) IBOutlet UIButton *NearByButton;// 附近

@property (strong, nonatomic) NSString *strMainType; // 0:公司 1:案例
@property (strong, nonatomic) NSString *strSelectStyleSort; // 0:公司风格 1:公司排序 2:案例风格 3:案例户型

@property (strong, nonatomic) NSMutableArray *styleCompanyNum;
@property (assign, nonatomic) NSInteger sortCompanyNum;
@property (strong, nonatomic) NSMutableArray *styleCaseNum;
@property (strong, nonatomic) NSMutableArray *sortCaseNum;

//数据源
@property (strong, nonatomic) NSArray *arrayCompanySortData;
@property (nonatomic, strong) NSMutableArray *storeList;
@property (nonatomic, strong) NSMutableArray *exampleList;

// 公司风格数据源
@property (nonatomic, strong) NSMutableArray *styleCompanyDataId;
@property (nonatomic, strong) NSMutableArray *styleCompanyDataName;
@property (nonatomic, strong) NSMutableArray *selectStyleCompanyId; // 公司选择的风格Id
@property (nonatomic, copy) NSString *selectsortCompany; // 公司选择的排序

// 案例风格数据源
@property (nonatomic, strong) NSMutableArray *styleCaseDataId;
@property (nonatomic, strong) NSMutableArray *styleCaseDataName;
@property (nonatomic, strong) NSMutableArray *selectStyleCsaeId; // 公司选择的风格Id

// 案例风格数据源
@property (nonatomic, strong) NSMutableArray *sortCaseDataId;
@property (nonatomic, strong) NSMutableArray *sortCaseDataName;
@property (nonatomic, strong) NSMutableDictionary *selectSortCaseId; // 案例选择的户型

//页数 翻页用
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic) NSInteger pageStore;
@property (nonatomic) NSInteger pageExample;

@property(nonatomic,strong)NSMutableArray *tagArray;//存储风格tag
@property(nonatomic,strong)NSMutableArray *sortTypeArray;//排序
@property(nonatomic,strong) NSMutableArray *array;
@property(nonatomic,strong) ActivityAlterView *activityView;
@property(nonatomic,strong)UIImage *alterImage;//活动弹框的图片
@end

@implementation BuildingMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self GetAcivityAlterView];
    _array=[[NSMutableArray alloc]init];
    _sortTypeArray=[NSMutableArray arrayWithObjects:@"default_order",@"dp_desc",@"appoint_desc",@"order_desc", nil];
    _storeList = [NSMutableArray array];
    _exampleList = [NSMutableArray array];
    
    _styleCompanyDataId = [NSMutableArray array];
    _styleCompanyDataName = [NSMutableArray array];
    _styleCompanyNum = [NSMutableArray array];
    _selectStyleCompanyId = [NSMutableArray array];
    
    _styleCaseDataName = [NSMutableArray array];
    _styleCaseDataId = [NSMutableArray array];
    _styleCaseNum = [NSMutableArray array];
    _selectStyleCsaeId = [NSMutableArray array];
    
    _sortCaseDataId = [NSMutableArray array];
    _sortCaseDataName = [NSMutableArray array];
    _sortCaseNum = [NSMutableArray array];
    _selectSortCaseId = [NSMutableDictionary dictionary];
    
    
     self.btnCompany.selected = YES;
    _keyword = @"";
    _selectsortCompany = @"default_order"; // 公司默认排序
  
    // 下拉刷新
    MJRefreshNormalHeader *headerSelected = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getStoredData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    headerSelected.automaticallyChangeAlpha = YES;
    // 隐藏时间
    headerSelected.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    [headerSelected beginRefreshing];
    // 设置header
    _tableViewCompany.mj_header = headerSelected;
    
 
    MJRefreshNormalHeader *headerTips = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCaseData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    headerTips.automaticallyChangeAlpha = YES;
    // 隐藏时间
    headerTips.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    [headerTips beginRefreshing];
    // 设置header
    _tableViewCase.mj_header = headerTips;
    
    
    //加载更多
    __weak typeof(self) weakSelf = self;
    _tableViewCompany.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf seachStore:weakSelf.keyword Page:weakSelf.pageStore + 1 tags:_selectStyleCompanyId sortType:_selectsortCompany];
    }];
    _tableViewCase.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf seachExample:weakSelf.keyword Page:weakSelf.pageExample + 1 tags:_selectStyleCsaeId sortType:_selectSortCaseId];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CityChanged) name:@"CityChanged" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableViewCompany.growingAttributesUniqueTag=@"storeList_ios";
    //self.tableViewCompany.leo_anaylizeTitle=@"storeList_ios";
    AppDelegate *appDelegate = APP_DELEGATE;
    //全部案例过来时，选中案例
    if ([@"1" isEqualToString:appDelegate.allExample]) {
        [self btnSelectCompanyCase:self.btnCase];
        appDelegate.allExample = @"";
    }
}
#pragma mark //活动弹框

-(void)GetAcivityAlterView{
    NSDictionary *param;
    
    param = [NSDictionary dictionaryWithObjectsAndKeys:DATA_ENV.userInfo.user.userLevel,@"popup_target",@"company",@"popup_location", nil];
    [ActivityAlterViewRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[ActivityAlterViewRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            NSLog(@"******==%@",request.resultDic);
            //_alterImage
            NSString *imageUrl=request.resultDic[@"data"][@"popup_pic_url"];
            NSData *data  = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            
            _alterImage=[UIImage imageWithData:data];
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"built"]){
                [self showAlterView:_alterImage];
                
            }else{
                NSLog(@"bool");
            }

            
        } else {
            
            //[self.view makeToast:@"失败" duration:1 position:CSToastPositionCenter];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
        [self.view makeToast:@"提交失败" duration:1 position:CSToastPositionCenter];
    }];
    
}
#pragma mark 弹出活动框
-(void)showAlterView:(UIImage *)image{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"built"];
    if (_activityView == nil) {
        _activityView = [[ActivityAlterView alloc]init];
        
        _activityView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        __weak typeof(self)WeakSelf = self;
        [_activityView setClickBlock:^(Alterclicktype type) {
            switch (type) {
                case Aclick_blank:
                    [WeakSelf.activityView dismiss];
                    WeakSelf.activityView = nil;
                    break;
                case Aclick_dismiss:
                    [WeakSelf.activityView dismiss];
                    WeakSelf.activityView = nil;
                    break;
                default:
                    break;
            }
        }];
        
        [self.view addSubview:_activityView];
    }
    _activityView.QRimage = image;
    [_activityView show];
    
}

- (void)CityChanged{
    [_tableViewCompany.mj_header beginRefreshing];
    [_tableViewCase.mj_header beginRefreshing];
}

- (void)getStoredData {
    [self seachStore:_keyword Page:0 tags:_selectStyleCompanyId sortType:_selectsortCompany];
     //[_tableViewCompany.mj_header endRefreshing];
}

- (void)getCaseData {
    [self seachExample:_keyword Page:0 tags:_selectStyleCsaeId sortType:_selectSortCaseId];
    // [_tableViewCase.mj_header endRefreshing];
}

#pragma mark - 数据源
- (NSArray *)arrayCompanySortData{
    if (_arrayCompanySortData == nil) {
        _arrayCompanySortData = [NSArray arrayWithObjects: @"默认排序",@"口碑排序",@"预约最多",@"点评最多",nil];
    }
    return _arrayCompanySortData;
}

#pragma mark - 公司案例选择
- (IBAction)btnSelectCompanyCase:(UIButton *)button {
    self.btnCompany.selected = NO;
    self.btnCase.selected = NO;
    self.viewSelectShow.hidden = YES;
    self.btnSort.selected = NO;
    self.btnStyle.selected = NO;
    self.imageViewSort.image = [UIImage imageNamed:@"展开箭头"];
    self.imageViewStyle.image = [UIImage imageNamed:@"展开箭头"];
    button.selected = YES;
    button.userInteractionEnabled = NO;
    switch (button.tag) {
        case 0:
            self.strMainType = @"0";
            self.btnCase.selected = NO;
            self.btnCase.userInteractionEnabled = YES;
            self.viewLineLeft.constant = 17;
            self.tableViewCase.hidden = YES;
            self.tableViewCompany.hidden = NO;
            [self.tableViewCompany reloadData];
            [self.btnSort setTitle:@"排序" forState:UIControlStateNormal];
            break;
        case 1:
            self.strMainType = @"1";
            self.btnCompany.selected = NO;
            self.btnCompany.userInteractionEnabled = YES;
            self.viewLineLeft.constant = 71;
            self.tableViewCase.hidden = NO;
            self.tableViewCompany.hidden = YES;
            [self.tableViewCase reloadData];
            [self.btnSort setTitle:@"户型" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
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
        [button setTitleColor:[UIColor colorWithRed:96/255.0 green:25/255.0 blue:134/255.0 alpha:1.0] forState:UIControlStateSelected];
        if ([self.strMainType integerValue] == 0) {
             self.strSelectStyleSort = @"0";
            NSInteger num = _styleCompanyDataName.count;
            [self creatSelectView:num andSelect:0];
        }else{
             self.strSelectStyleSort = @"2";
            [self creatSelectView:_styleCaseDataName.count andSelect:0];
        }
        self.imageViewStyle.image = [UIImage imageNamed:@"收回箭头2"];
        button.selected = YES;
        self.viewSelectShow.hidden = NO;
        [self moveanimations];
    }
    
}

// 排序选择
- (IBAction)btnSort:(UIButton *)button {
    self.btnStyle.selected = NO;
    self.imageViewStyle.image = [UIImage imageNamed:@"展开箭头"];
    if (button.selected) {
        button.selected = NO;
        self.viewSelectShow.hidden = YES;
        self.imageViewSort.image = [UIImage imageNamed:@"展开箭头"];
    }else{
        [button setTitleColor:[UIColor colorWithRed:96/255.0 green:25/255.0 blue:134/255.0 alpha:1.0] forState:UIControlStateSelected];

        if ( [self.strMainType integerValue] == 0) {
            self.strSelectStyleSort = @"1";
            [self creatSelectView:self.arrayCompanySortData.count andSelect:self.sortCompanyNum];
        }else{
            self.strSelectStyleSort = @"3";
            [self creatSelectView:self.sortCaseDataName.count andSelect:0];
        }
        button.selected = YES;
        self.imageViewSort.image = [UIImage imageNamed:@"收回箭头2"];
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
        btnName.backgroundColor=[UIColor whiteColor];
        UIButton *SureButton=[[UIButton alloc]init];
        //        UIButton *SureButton=[[UIButton alloc]initWithFrame:CGRectMake(15 + (btnWide + 15) *1, 30 +38 * num/4, 2*btnWide+15, 40)];
        SureButton.backgroundColor=[UIColor colorWithRed:88/255.0 green:21/255.0 blue:121/255.0 alpha:1];
        [SureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [SureButton setTitle:@"确定" forState:UIControlStateNormal];
        SureButton.layer.cornerRadius = 3;
        SureButton.tag=10086;
        SureButton.hidden=NO;
        [SureButton addTarget:self action:@selector(HideSelectView) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *line=[[UILabel alloc]init];
        line.backgroundColor=[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
        // [self.viewSelectShow addSubview:line];
        [self.viewSelectShow addSubview:SureButton];
        // 0:公司风格 1:公司排序 2:案例风格 3:案例户型
        if ([self.strSelectStyleSort integerValue] == 1) {
            
            [btnName setTitle:[self.arrayCompanySortData[a] description] forState:UIControlStateNormal];
            if (a == 0) {
                btnName.backgroundColor=[UIColor colorWithRed:230/255.0 green:221/255.0 blue:233/255.0 alpha:1.0];
                btnName.layer.borderColor=[UIColor colorWithRed:172/255.0 green:136/255.0 blue:191/255.0 alpha:1.0].CGColor;
                btnName.selected=YES;
            }
            SureButton.frame=CGRectMake(15 + (btnWide + 15) *1, 24 +38 * num/4, 2*btnWide+15, 0);
            SureButton.hidden=YES;
            //line.hidden=YES;
        }else if( [self.strSelectStyleSort integerValue] == 0){
            [btnName setTitle:[_styleCompanyDataName[a] description] forState:UIControlStateNormal];
            SureButton.frame=CGRectMake(15 + (btnWide + 15) *1, 24 +38 * num/4, 2*btnWide+15, 40);
            //line.frame=CGRectMake(0, SureButton.frame.origin.y-10, [UIScreen mainScreen].bounds.size.width, 0.5);
        }else if( [self.strSelectStyleSort integerValue] == 2){
            [btnName setTitle:[_styleCaseDataName[a] description] forState:UIControlStateNormal];
            SureButton.frame=CGRectMake(15 + (btnWide + 15) *1, 24 +38 * num/4, 2*btnWide+15, 40);
            //line.frame=CGRectMake(0, SureButton.frame.origin.y-10, [UIScreen mainScreen].bounds.size.width, 0.5);
        }else if( [self.strSelectStyleSort integerValue] == 3){
            SureButton.frame=CGRectMake(15 + (btnWide + 15) *1, 24+15 +38 * (num+1)/4, 2*btnWide+15, 40);
            // line.frame=CGRectMake(0, SureButton.frame.origin.y-10, [UIScreen mainScreen].bounds.size.width, 0.5);
            if (a == 0) {
                [btnName setTitle:[_sortCaseDataName[a] description] forState:UIControlStateNormal];
//                [btnName setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
//                btnName.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
//                btnName.layer.borderWidth = 0.5;
                btnName.backgroundColor=[UIColor colorWithRed:230/255.0 green:221/255.0 blue:233/255.0 alpha:1.0];
                btnName.layer.borderColor=[UIColor colorWithRed:172/255.0 green:136/255.0 blue:191/255.0 alpha:1.0].CGColor;
                btnName.selected=YES;
            }else{
                NSDictionary *dic = _sortCaseDataName[a];
                [btnName setTitle:[dic[@"value"] description] forState:UIControlStateNormal];
            }
        }
        else{
            [btnName setTitle:@"默认排序" forState:UIControlStateNormal];
            [btnName setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
            btnName.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
            btnName.layer.borderWidth = 0.5;
        }
        btnName.layer.borderWidth = 0.5;
        btnName.tag = a+100;
        btnName.titleLabel.font = [UIFont systemFontOfSize:12];
        btnName.layer.cornerRadius = 3;
        btnName.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
        [btnName setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btnName setTitleColor:[UIColor colorWithRed:96/255.0 green:25/255.0 blue:134/255.0 alpha:1.0] forState:UIControlStateSelected];
        if( [self.strSelectStyleSort integerValue] == 0){
            if (_styleCompanyNum.count == 0) {
                if (a == 0) {
                    //btnName.backgroundColor=[UIColor redColor];
//                    btnName.layer.borderWidth = 0.5;
//                    btnName.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
//                    [btnName setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
                    btnName.backgroundColor=[UIColor colorWithRed:230/255.0 green:221/255.0 blue:233/255.0 alpha:1.0];
                    btnName.layer.borderColor=[UIColor colorWithRed:172/255.0 green:136/255.0 blue:191/255.0 alpha:1.0].CGColor;
                    btnName.selected=YES;
                }
            }else{
                for (NSString *num in _styleCompanyNum) {
                    if ([num integerValue] == a) {
                        btnName.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
                        [btnName setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
                        
                    }
                }
            }
            
        }else  if( [self.strSelectStyleSort integerValue] == 2){
            if (_styleCaseNum.count == 0) {
                if (a == 0) {
//                    btnName.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
//                    [btnName setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
//                    btnName.layer.borderWidth = 0.5;
                    btnName.backgroundColor=[UIColor colorWithRed:230/255.0 green:221/255.0 blue:233/255.0 alpha:1.0];
                    btnName.layer.borderColor=[UIColor colorWithRed:172/255.0 green:136/255.0 blue:191/255.0 alpha:1.0].CGColor;
                    btnName.selected=YES;
                    
                }
            }else{
                for (NSString *num in _styleCaseNum) {
                    if ([num integerValue] == a) {
                        btnName.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
                        [btnName setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
                        
                    }
                }
            }
            
        }else  if( [self.strSelectStyleSort integerValue] == 3){
            if (_sortCaseNum.count == 0) {
                if (a == 0) {
//                    btnName.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
//                    [btnName setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
//                    btnName.layer.borderWidth = 0.5;
                    btnName.backgroundColor=[UIColor colorWithRed:230/255.0 green:221/255.0 blue:233/255.0 alpha:1.0];
                    btnName.layer.borderColor=[UIColor colorWithRed:172/255.0 green:136/255.0 blue:191/255.0 alpha:1.0].CGColor;
                    btnName.selected=YES;

                }
            }else{
                for (NSString *num in _sortCaseNum) {
                    if ([num integerValue] == a) {
                        btnName.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
                        [btnName setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
                        
                    }
                }
            }
            
        }
        else{
            if (a == selectNum) {
                btnName.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
                [btnName setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
                
            }
        }
        // UIButton *btnName = [[UIButton alloc] initWithFrame:CGRectMake(15 + (btnWide + 15) *beiyushu , 13 +38 * yushu, btnWide, 25)];
        line.frame=CGRectMake(0, 13+38*(num/4), [UIScreen mainScreen].bounds.size.width, 0.5);
        if( [self.strSelectStyleSort integerValue] == 3){
            line.frame=CGRectMake(0, 13+38*(num)/4+25, [UIScreen mainScreen].bounds.size.width, 0.5);
        }
        [btnName addTarget:self action:@selector(selectShow:) forControlEvents:UIControlEventTouchUpInside];
        for (id obj in self.viewSelectShow.subviews) {
            if ([obj isKindOfClass:[UILabel class]]) {
                [obj removeFromSuperview];
            }
        }
        [self.viewSelectShow addSubview:btnName];
        [self.viewSelectShow addSubview:line];
    }
    float yushu = num/4;
    float beiyushu = num%4;
    UIButton *lastBut=(UIButton *)[self.view viewWithTag:10086];
    if (beiyushu == 0) {
        self.viewSelectHeight.constant = 13 + 38 * yushu+lastBut.frame.size.height+20 ;
    }else{
        self.viewSelectHeight.constant = 13 + 38 *( yushu + 1)+lastBut.frame.size.height+20;
    }
    if ([self.strSelectStyleSort integerValue] == 1){
        self.viewSelectHeight.constant = 13 + 38 *( yushu )+lastBut.frame.size.height;
    }
    
    
}
-(void)HideSelectView{
    
    self.viewSelectShow.hidden = YES;
    self.btnSort.selected = NO;
    self.btnStyle.selected = NO;
    self.imageViewSort.image = [UIImage imageNamed:@"展开箭头"];
    self.imageViewStyle.image = [UIImage imageNamed:@"展开箭头"];
    NSLog(@"array==%@",_array);
//    for(int i=0;i<_array.count;i++){
//        [_tagArray removeObjectAtIndex:[_array[i] intValue]-102];
//    }
//    NSLog(@"7777==%@",_tagArray);
    [self seachStore:_keyword Page:0 tags:_tagArray sortType:@""];
//    for (id obj in self.viewSelectShow.subviews) {
//        if ([obj isKindOfClass:[UIButton class]]) {
//            UIButton* theButton = (UIButton*)obj;
//            if(theButton.tag!=100&&theButton.tag!=10086&&theButton.selected==NO){
//                NSLog(@"****==%ld",theButton.tag);//102
//              
//                NSString *str=[NSString stringWithFormat:@"%ld",theButton.tag-102];
//                [_array addObject:str];
//               // [_tagArray removeObjectAtIndex:theButton.tag-102];
//               // [self seachStore:_keyword Page:0 tags:_tagArray sortType:@""];
//
//                NSLog(@"dataSource==%@",_array);
//                
//            }
//            for(int i=0;i<_array.count;i++){
//                [_tagArray removeObjectAtIndex:[_array[i] intValue]];
//            }
//            [self seachStore:_keyword Page:0 tags:_tagArray sortType:@""];
       // }}

    [_tableViewCompany.mj_header beginRefreshing];
    
}

// 选择显示类型
- (void)selectShow:(UIButton *)btn{
    
    
    NSLog(@"==%ld",self.sortCompanyNum);
   
    if ([self.strSelectStyleSort integerValue] == 1){
        for(int i=0;i<4;i++){
            if(btn.tag==i+100){
                btn.selected=YES;
                 btn.backgroundColor=[UIColor colorWithRed:230/255.0 green:221/255.0 blue:233/255.0 alpha:1.0];
                btn.layer.borderColor=[UIColor colorWithRed:172/255.0 green:136/255.0 blue:191/255.0 alpha:1.0].CGColor;
                NSLog(@"********==%@",_sortTypeArray[i]);
                [self seachStore:_keyword Page:0 tags:@[] sortType:_sortTypeArray[i]];
                [_tableViewCompany.mj_header beginRefreshing];

                continue;
            }
            UIButton *last=(UIButton *)[self.view viewWithTag:i+100];
            last.selected=NO;
            last.backgroundColor=[UIColor whiteColor];
            last.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
        }
    }else{
         UIButton *but=(UIButton *)[self.view viewWithTag:100];
    if(btn.tag==100){
         btn.selected=!btn.selected;
        if(btn.selected==YES){
            btn.backgroundColor=[UIColor colorWithRed:230/255.0 green:221/255.0 blue:233/255.0 alpha:1.0];
            btn.layer.borderColor=[UIColor colorWithRed:172/255.0 green:136/255.0 blue:191/255.0 alpha:1.0].CGColor;
//            for (id obj in self.viewSelectShow.subviews) {
//                if ([obj isKindOfClass:[UIButton class]]) {
//                UIButton* theButton = (UIButton*)obj;
//                    if(theButton.tag!=100&&theButton.tag!=10086){
//                    theButton.selected=NO;
//                        theButton.backgroundColor=[UIColor whiteColor];
//                    }
//                }}
        }else{
            btn.backgroundColor=[UIColor whiteColor];
            btn.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
            
        }
    }else{
    
    if(btn.selected==NO){
        but.selected=NO;
        but.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
        but.backgroundColor=[UIColor whiteColor];
        btn.backgroundColor=[UIColor colorWithRed:230/255.0 green:221/255.0 blue:233/255.0 alpha:1.0];
        btn.layer.borderColor=[UIColor colorWithRed:172/255.0 green:136/255.0 blue:191/255.0 alpha:1.0].CGColor;
        //btn.layer.borderColor=[UIColor colorWithRed:96/255.0 green:25/255.0 blue:134/255.0 alpha:1.0].CGColor;
        btn.selected=YES;
    }else{
        btn.backgroundColor=[UIColor whiteColor];
        btn.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
        //btn.layer.borderColor=[UIColor grayColor].CGColor;
        btn.selected=NO;
        if (btn.tag!=100) {
             [_array addObject:[NSString stringWithFormat:@"%ld",btn.tag]];
        }
       

    }
    }
    }
//    if ([self.strSelectStyleSort integerValue] == 1&&btn.selected==YES){
//         [_tableViewCompany.mj_header beginRefreshing];
//    }
//    if ([self.strSelectStyleSort integerValue] == 0) {
//        if(btn.tag == 0){
//            [self.selectStyleCompanyId removeAllObjects];
//            [self.styleCompanyNum removeAllObjects];
//             [_tableViewCompany.mj_header beginRefreshing];
//        }else{
//            NSString *tag = [NSString stringWithFormat:@"%ld",btn.tag];
//            if(![self.styleCompanyNum containsObject:tag]){
//                [self.styleCompanyNum addObject:tag];
//            }else{
//                [self.styleCompanyNum removeObject:tag];
//            }
//            [self.selectStyleCompanyId removeAllObjects];
//            for (NSString *num in _styleCompanyNum) {
//                [self.selectStyleCompanyId addObject:[_styleCompanyDataId[[num integerValue] -1] description]];
//            }
//            [_tableViewCompany.mj_header beginRefreshing];
//          
//        }
//
//        [self creatSelectView:_styleCompanyDataName.count andSelect:btn.tag];
//    }else  if ([self.strSelectStyleSort integerValue] == 1) {
//        self.sortCompanyNum = btn.tag;
//        //default_order综合排序(默认),  order_desc 点评 appoint_desc 预约最多  dp_desc 口碑
//        if ( self.sortCompanyNum == 0) {
//            _selectsortCompany = @"default_order"; // 公司默认排序
//        }else if (self.sortCompanyNum == 1){
//             _selectsortCompany = @"order_desc";
//        }
//        else if (self.sortCompanyNum == 2){
//            _selectsortCompany = @"appoint_desc";
//        }
//        else if (self.sortCompanyNum == 3){
//            _selectsortCompany = @"dp_desc";
//        }
//        [self creatSelectView:self.arrayCompanySortData.count andSelect:btn.tag];
//        [_tableViewCompany.mj_header beginRefreshing];
//    }else  if ([self.strSelectStyleSort integerValue] == 2) {
//   
//        if(btn.tag == 0){
//            [self.selectStyleCsaeId removeAllObjects];
//            [self.styleCaseNum removeAllObjects];
//            
//             [_tableViewCase.mj_header beginRefreshing];
//        }else{
//            NSString *tag = [NSString stringWithFormat:@"%ld",btn.tag];
//            if(![self.styleCaseNum containsObject:tag]){
//                [self.styleCaseNum addObject:tag];
//            }else{
//                [self.styleCaseNum removeObject:tag];
//            }
//            [self.selectStyleCsaeId removeAllObjects];
//            for (NSString *num in _styleCaseNum) {
//                [self.selectStyleCsaeId addObject:[_styleCaseDataId[[num integerValue] -1] description]];
//            }
//             [_tableViewCase.mj_header beginRefreshing];
//        }
//        
//        [self creatSelectView:_styleCaseDataName.count andSelect:btn.tag];
//        
//    }else  if ([self.strSelectStyleSort integerValue] == 3) {
// 
//        if(btn.tag == 0){
//            [self.selectSortCaseId removeAllObjects];
//            [self.sortCaseNum removeAllObjects];
//            [_tableViewCase.mj_header beginRefreshing];
//           // [self seachExample:_keyword Page:0 tags:_selectStyleCsaeId sortType:_selectSortCaseId];
//        }else{
//            NSString *tag = [NSString stringWithFormat:@"%ld",btn.tag];
//            if(![self.sortCaseNum containsObject:tag]){
//                [self.sortCaseNum addObject:tag];
//            }else{
//                [self.sortCaseNum removeObject:tag];
//            }
//            [self.selectSortCaseId removeAllObjects];
//            for (NSString *num in _sortCaseNum) {
//                NSDictionary *dic = _sortCaseDataName[[num integerValue]];
//                [_selectSortCaseId setObject:[dic[@"attr_id"] description] forKey:[dic[@"attrval_id"] description]];
//            }
//            [_tableViewCase.mj_header beginRefreshing];
//            //[self seachExample:_keyword Page:0 tags:_selectStyleCsaeId sortType:_selectSortCaseId];
//        }
//        
//        [self creatSelectView:_sortCaseDataName.count andSelect:btn.tag];
//        
//    }
//    self.viewSelectShow.hidden = YES;
//    self.btnSort.selected = NO;
//    self.btnStyle.selected = NO;
//    self.imageViewSort.image = [UIImage imageNamed:@"展开箭头"];
//    self.imageViewStyle.image = [UIImage imageNamed:@"展开箭头"];
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

#pragma mark - 按钮点击
- (IBAction)btnCilckNearby:(id)sender {
    CompanySearchViewController *view = [[CompanySearchViewController alloc] initWithNibName:@"CompanySearchViewController" bundle:nil];
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableViewCompany) {
        Store *storeData = _storeList[indexPath.row];
        NSInteger num = storeData.albumList.count;
        if (num == 0) {
            return 100;
        }else{
            return 200;
        }
    }else if (tableView == _tableViewCase){
         return 280;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableViewCompany) {
        return _storeList.count;
    }else if (tableView == _tableViewCase){
        return _exampleList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tableViewCompany) {
        static NSString *identity = @"CompanyTableViewCell";
        CompanyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identity];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"CompanyTableViewCell" bundle:nil] forCellReuseIdentifier:identity];
            cell = [tableView dequeueReusableCellWithIdentifier:identity];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        Store *storeData = _storeList[indexPath.row];
        [cell loadData:storeData];
        cell.btnCaseOne.tag = indexPath.row;
        [cell.btnCaseOne addTarget:self action:@selector(btnGoCaseDetailOne:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnCaseTwo.tag = indexPath.row;
        [cell.btnCaseTwo addTarget:self action:@selector(btnGoCaseDetailTwo:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnCaseThree.tag = indexPath.row;
        [cell.btnCaseThree addTarget:self action:@selector(btnGoCaseDetailThree:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (tableView == _tableViewCase){
        static NSString *identity = @"CaseTableViewCell";
        CaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identity];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"CaseTableViewCell" bundle:nil] forCellReuseIdentifier:identity];
            cell = [tableView dequeueReusableCellWithIdentifier:identity];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
         cell.viewTopLine.hidden = NO;
        if (indexPath.row == 0) {
            cell.viewTopLine.hidden = YES;
        }
        BuildingExample *exampleData = _exampleList[indexPath.row];
        [cell loadData:exampleData];
        return cell;
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableViewCompany) {
        Store *storeData = _storeList[indexPath.row];
        CompanyHomeViewController *view = [[CompanyHomeViewController alloc] initWithNibName:@"CompanyHomeViewController" bundle:nil];
        view.storeId = storeData.storeId;
        [self.navigationController pushViewController:view animated:YES];
    }else if (tableView == _tableViewCase){
        BuildingExample *exampleData = _exampleList[indexPath.row];
        CaseHomeViewController *view = [[CaseHomeViewController alloc] initWithNibName:@"CaseHomeViewController" bundle:nil];
        view.albumId = exampleData.albumId;
        [self.navigationController pushViewController:view animated:YES];
    }
    
}

- (void) btnGoCaseDetailOne:(UIButton *)sender{
    Store *storeData = _storeList[sender.tag];
    NSDictionary *albumDic = storeData.albumList[0];
    [self goCaseDetail:albumDic];
}

- (void) btnGoCaseDetailTwo:(UIButton *)sender{
    Store *storeData = _storeList[sender.tag];
    NSDictionary *albumDic = storeData.albumList[1];
    [self goCaseDetail:albumDic];
}


- (void) btnGoCaseDetailThree:(UIButton *)sender{
    Store *storeData = _storeList[sender.tag];
     NSDictionary *albumDic = storeData.albumList[2];
    [self goCaseDetail:albumDic];
}

- (void) goCaseDetail:(NSDictionary*)albumDic{
    CaseHomeViewController *view = [[CaseHomeViewController alloc] initWithNibName:@"CaseHomeViewController" bundle:nil];
    view.albumId = [albumDic[@"album_id"] description];
    [self.navigationController pushViewController:view animated:YES];
}
//检索店铺
- (void)seachStore:(NSString *)keyword Page:(NSInteger)page tags:(id)tags sortType:(NSString *)sortType {

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:keyword forKey:@"keyword"];
    [parameters setValue:@"2011" forKey:@"cate_id"];
    [parameters setValue:tags forKey:@"tags"];
    [parameters setValue:@"list" forKey:@"type"];
    [parameters setValue:@"1" forKey:@"add_example"];
    [parameters setValue:sortType forKey:@"sort_type"];
    [parameters setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setValue:@10 forKey:@"size"];
    __weak typeof(self) weakSelf = self;
    [SearchStoreRequest requestWithParameters:parameters
                                withCacheType:DataCacheManagerCacheTypeMemory
                            withIndicatorView:nil
                            withCancelSubject:[SearchStoreRequest getDefaultRequstName]
                               onRequestStart:nil
                            onRequestFinished:^(CIWBaseDataRequest *request) {
                                
                                if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                                    weakSelf.pageStore = page;
                                    
                                    if (weakSelf.pageStore == 0) {
                                        weakSelf.storeList = [NSMutableArray array];
                                    }
                                    
                                    NSArray *array = [request.resultDic objectForKey:@"store"];
                                    if (array.count > 0) {
                                        [weakSelf.storeList addObjectsFromArray:array];
                                    }
                                    
                                    [_tableViewCompany reloadData];
                                    
                                    NSLog(@"data==%@",request.resultDic);
                                    //条数
                                    NSInteger total = [[request.resultDic objectForKey:@"total"] integerValue];
                                    NSDictionary *dicTags = [NSDictionary dictionaryWithDictionary:[request.resultDic objectForKey:@"tags"]];
                                    NSArray* allKeys = [dicTags allKeys];
                                    NSMutableArray* allValue = [NSMutableArray array];
                                    for (NSString* key in allKeys) {
                                        [allValue addObject:[dicTags valueForKey:key]];
                                    }
                                    _styleCompanyDataId = [NSMutableArray arrayWithArray:allKeys];
                                    _styleCompanyDataName = [NSMutableArray arrayWithArray:allValue];
                                    NSLog(@"tag==%@",allKeys);
                                    _tagArray=[NSMutableArray arrayWithArray:allKeys];
                                    [_styleCompanyDataName insertObject:@"全部" atIndex:0];
                                    
                                    if (weakSelf.storeList.count >= total) {
                                        [_tableViewCompany.mj_footer endRefreshingWithNoMoreData];
                                    } else {
                                        [_tableViewCompany.mj_footer resetNoMoreData];
                                    }
                                }
                                
                                if ([_tableViewCompany.mj_footer isRefreshing]) {
                                    [_tableViewCompany.mj_footer endRefreshing];
                                }
                                _tableViewCompany.tag = 1;
                              
                                  [_tableViewCompany.mj_header endRefreshing];
                            }
                            onRequestCanceled:^(CIWBaseDataRequest *request) {
                                if ([_tableViewCompany.mj_footer isRefreshing]) {
                                    [_tableViewCompany.mj_footer endRefreshing];
                                }
                                [_tableViewCompany.mj_header endRefreshing];
                                _tableViewCompany.tag = 1;
                            }
                              onRequestFailed:^(CIWBaseDataRequest *request) {
                                  if ([_tableViewCompany.mj_footer isRefreshing]) {
                                      [_tableViewCompany.mj_footer endRefreshing];
                                  }
                                    [_tableViewCompany.mj_header endRefreshing];
                                  _tableViewCompany.tag = 1;
                              }];
}

//检索案例
- (void)seachExample:(NSString *)keyword Page:(NSInteger)page tags:(id)tags sortType:(id)sortType {
 
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
   // [parameters setValue:@"110900" forKey:@"city_id"];
    [parameters setValue:keyword forKey:@"keyword"];
    [parameters setValue:@"" forKey:@"latlng"];
    [parameters setValue:tags forKey:@"tags"];
    [parameters setValue:sortType forKey:@"attrs"];
    [parameters setValue:@"list" forKey:@"type"];
    [parameters setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [parameters setValue:@10 forKey:@"size"];

    __weak typeof(self) weakSelf = self;
    [GetExampleListRequest requestWithParameters:parameters
                                  withCacheType:DataCacheManagerCacheTypeMemory
                              withIndicatorView:nil
                              withCancelSubject:[GetExampleListRequest getDefaultRequstName]
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
                                      
                                      [_tableViewCase reloadData];
                                      
                                      //条数
                                      NSInteger total = [[request.resultDic objectForKey:@"total"] integerValue];
                                      
                                      // 风格
                                      NSDictionary *tagMap = [NSDictionary dictionaryWithDictionary:[request.resultDic objectForKey:@"tagMap"]];
                                      NSArray* allKeys = [tagMap allKeys];
                                      NSMutableArray* allValue = [NSMutableArray array];
                                      for (NSString* key in allKeys) {
                                          [allValue addObject:[tagMap valueForKey:key]];
                                      }
                                      _styleCaseDataId = [NSMutableArray arrayWithArray:allKeys];
                                      _styleCaseDataName = [NSMutableArray arrayWithArray:allValue];
                                      [_styleCaseDataName insertObject:@"全部" atIndex:0];
                                      
                                      // 户型
                                      NSDictionary *attrMap = [NSDictionary dictionaryWithDictionary:[request.resultDic objectForKey:@"attrMap"]];
                                      NSArray* allKeysAttr = [attrMap allKeys];
                                      if (allKeys.count > 0) {
                                          NSString *key = [allKeysAttr[0] description];
                                          _sortCaseDataName = [NSMutableArray arrayWithArray:attrMap[key]];
                                          [_sortCaseDataName insertObject:@"全部" atIndex:0];
                                      }
                                      
                                      if (weakSelf.exampleList.count >= total) {
                                          [_tableViewCase.mj_footer endRefreshingWithNoMoreData];
                                      } else {
                                          [_tableViewCase.mj_footer resetNoMoreData];
                                      }
                                  }
                                  
                                  if ([_tableViewCase.mj_footer isRefreshing]) {
                                      [_tableViewCase.mj_footer endRefreshing];
                                  }
                                  _tableViewCase.tag = 1;
                                  [_tableViewCase.mj_header endRefreshing];
                              }
                              onRequestCanceled:^(CIWBaseDataRequest *request) {
                                  if ([_tableViewCase.mj_footer isRefreshing]) {
                                      [_tableViewCase.mj_footer endRefreshing];
                                  }
                                [_tableViewCase.mj_header endRefreshing];
                                  _tableViewCase.tag = 1;
                              }
                                onRequestFailed:^(CIWBaseDataRequest *request) {
                                    if ([_tableViewCase.mj_footer isRefreshing]) {
                                        [_tableViewCase.mj_footer endRefreshing];
                                    }
                                    [_tableViewCase.mj_header endRefreshing];
                                    _tableViewCase.tag = 1;
                                }];
}


@end
