//
//  HomeViewController.m
//  JiaZhuang
//
//  Created by 金伟城 on 16/12/26.
//  Copyright © 2016年 hzdaoshun. All rights reserved.
//

#import "HomeViewController.h"
#import "UIColor-Expanded.h"
#import "MJRefresh.h"
#import "GetContentRequest.h"
#import "GetHomeSelectedRequest.h"
#import "GetHomeTipsRequest.h"
#import "HomeBannerTableViewCell.h"
#import "HomeActivityTableViewCell.h"
#import "HomeExampleTableViewCell.h"
#import "LCBannerView.h"
#import "Banner.h"
#import "AdContent.h"
#import "Category.h"
#import "Activity.h"
#import "Example.h"
#import "Knowledge.h"
#import "Classroom.h"
#import "Strategy.h"
#import "HomeContentView.h"
#import "UIImageView+WebCache.h"
#import "WebViewController.h"
#import "ClassroomTableViewCell.h"
#import "SearchViewController.h"
#import "SwitchCityViewController.h"
#import "DSButton.h"
#import "GetRenovationTopicRequest.h"
#import "RenovationTopic.h"
#import "GoodSelectTableViewCell.h"
#import "RenovationShopDetialViewController.h"
#import "CaseHomeViewController.h"
#import "ScanViewController.h"
#import "ActivityListViewController.h"
#import "AppointDesignViewController.h"
#import "DecorateViewController.h"
#import "CouponViewController.h"
#import "AppDelegate.h"
#import "RenovationCategoryViewController.h"
#import "MessageViewController.h"

#import "ActivityAlterViewRequest.h"

#import "ActivityAlterView.h"

#import "Growing.h"
#define kBannerSection 0
#define kActivitySection 1
#define kAdSection 2
#define kExampleSection 3
#define kAdSelectedZxSection 4
#define kSelectedTopicSection 5

//#define kBannerSection 0
#define kAdTipsKnowledgeSection 1
#define kClassroomSection 2
#define kAdTipsClassroomSection 3
#define kStrategySection 4
#define kAdTipsStrategySection 5
#define kTipsTopicSection 6

//广告名称
#define kAdSelectedActivity @"index_selected_activity_1080x260"
#define kAdSelectedZx @"index_selected_zx_1080x260"
#define kAdTipsKnowledge @"index_tips_knowledge_1080x260"
#define kAdTipsClassroom @"index_tips_classroom_1080x260"
#define kAdTipsStrategy @"index_tips_strategy_1080x260"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, LCBannerViewDelegate> {
    __weak IBOutlet UITableView *_tableViewSelected;
    __weak IBOutlet UITableView *_tableViewTips;

    __weak IBOutlet UIButton *_btnLocation;
    __weak IBOutlet UIButton *_btnSelected;
    
    __weak IBOutlet UIButton *_btnTips;
    
    __weak IBOutlet NSLayoutConstraint *_leftViewline;
}

@property (nonatomic) NSInteger selectPage;

//精选
//轮播图
@property (nonatomic, strong) NSArray *bannerSelectedList;
//导航入口
@property (nonatomic, strong) NSArray *categorySelectedList;
//活动入口
@property (nonatomic, strong) NSArray *activitySelectedList;
//装修案例
@property (nonatomic, strong) NSArray *exampleSelectedList;

//攻略
//轮播图
@property (nonatomic, strong) NSArray *bannerTipsList;
//装修知识
@property (nonatomic, strong) NSArray *knowledgeTipsList;
//家芭莎课堂
@property (nonatomic, strong) NSArray *classroomTipsList;
//买货攻略
@property (nonatomic, strong) NSArray *strategyTipsList;

//广告
@property (nonatomic, strong) NSMutableDictionary *adContent;

//专题推荐
@property (nonatomic, strong) NSArray *selectedTopicList;
@property (nonatomic, strong) NSArray *tipsTopicList;


@property(nonatomic,strong) ActivityAlterView *activityView;
@property(nonatomic,strong)UIImage *alterImage;//活动弹框的图片
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self GetAcivityAlterView];
    // Do any additional setup after loading the view from its nib.
    [_btnLocation setTitle:DATA_ENV.city.sname forState:UIControlStateNormal];

    self.selectPage = 0;
    _btnSelected.tag = 1;
    self.adContent = [NSMutableDictionary dictionary];
    
    MJRefreshNormalHeader *headerSelected = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getSelectedData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    headerSelected.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    headerSelected.lastUpdatedTimeLabel.hidden = YES;
    
    // 马上进入刷新状态
    [headerSelected beginRefreshing];
    
    // 设置header
    _tableViewSelected.mj_header = headerSelected;

    //攻略
    MJRefreshNormalHeader *headerTips = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getTipsData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    headerTips.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    headerTips.lastUpdatedTimeLabel.hidden = YES;

    // 设置header
    _tableViewTips.mj_header = headerTips;
    
    //注册tableViewCell
    [_tableViewSelected registerNib:[UINib nibWithNibName:@"HomeBannerTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"HomeBannerTableViewCell"];
    [_tableViewSelected registerNib:[UINib nibWithNibName:@"HomeActivityTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"HomeActivityTableViewCell"];
    [_tableViewSelected registerNib:[UINib nibWithNibName:@"HomeExampleTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"HomeExampleTableViewCell"];
    [_tableViewSelected registerNib:[UINib nibWithNibName:@"GoodSelectTableViewCell" bundle:nil]
     forCellReuseIdentifier:@"GoodSelectTableViewCell"];
    
    [_tableViewTips registerNib:[UINib nibWithNibName:@"HomeBannerTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"HomeBannerTableViewCell"];
    [_tableViewTips registerNib:[UINib nibWithNibName:@"ClassroomTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"ClassroomTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.growingAttributesPageName=@"home_ios";
    NSString *cityname = _btnLocation.currentTitle;
    if (![DATA_ENV.city.sname isEqualToString:cityname]) {
        [_btnLocation setTitle:DATA_ENV.city.sname forState:UIControlStateNormal];
        
        if (self.selectPage == 0) {
            [_tableViewSelected.mj_header beginRefreshing];
            _btnTips.tag = 0;
        } else {
            [_tableViewTips.mj_header beginRefreshing];
            _btnSelected.tag = 0;
        }
    }
}
#pragma mark //活动弹框

-(void)GetAcivityAlterView{
    NSDictionary *param;
    
    param = [NSDictionary dictionaryWithObjectsAndKeys:DATA_ENV.userInfo.user.userLevel,@"popup_target",@"index",@"popup_location", nil];
    [ActivityAlterViewRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[ActivityAlterViewRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            NSLog(@"******==%@",request.resultDic);
            //_alterImage
            NSString *imageUrl=request.resultDic[@"data"][@"popup_pic_url"];
            NSData *data  = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            
            _alterImage=[UIImage imageWithData:data];
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"home"]){
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
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"home"];
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

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _tableViewSelected) {
        
//        if (indexPath.section ==  kSelectedTopicSection) {
//            //发现好家
//            RenovationTopic *renovationTopic = _selectedTopicList[indexPath.row];
//            [self openWebView:renovationTopic.topicUrl];
//        }
    } else if (tableView == _tableViewTips) {
//        if (indexPath.section ==  kTipsTopicSection) {
//            //热门话题
//            RenovationTopic *renovationTopic = _tipsTopicList[indexPath.row];
//            [self openWebView:renovationTopic.topicUrl];
//        }
    }
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == _tableViewSelected) {
        //精选
        // 0-轮播图,导航入口 1-广告 2-活动入口 3-装修案例 4-广告 5-发现好家
        return 6;
    } else {
        //攻略
        // 0-轮播图,装修知识 1-广告 2-家芭莎课堂 3-广告 4-买货攻略 5-广告 6-热门话题
        return 7;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _tableViewSelected) {
        //精选
        // 0-轮播图,导航入口 1-活动入口 2-装修案例
        if (section == kBannerSection) {
            return 2;
        } else if (section == kAdSection) {
            NSArray *adList = [self.adContent objectForKey:kAdSelectedActivity];
            // 增加 空白行
            return adList.count > 0?2:0;
        } else if (section == kActivitySection) {
            // 增加 空白行
            return self.activitySelectedList.count > 0?2:0;
        } else if (section == kExampleSection) {
            // 增加 空白行
            return self.exampleSelectedList.count > 0?(self.exampleSelectedList.count + 1):0;
        } else if (section == kAdSelectedZxSection) {
            NSArray *adList = [self.adContent objectForKey:kAdSelectedZx];
            // 增加 空白行
            return adList.count > 0?2:0;
        } else if (section  == kSelectedTopicSection) {
            return self.selectedTopicList.count;
        }
    } else {
        //攻略
        // 0-轮播图,装修知识 1-家芭莎课堂 2-买货攻略
        if (section == kBannerSection) {
            return 2;
        } else if (section == kAdTipsKnowledgeSection) {
            NSArray *adList = [self.adContent objectForKey:kAdTipsKnowledge];
            // 增加 空白行
            return adList.count > 0?2:0;
        } else if (section == kClassroomSection) {
            //家芭莎课堂 增加 空白行
            return self.classroomTipsList.count > 0?2:0;
        } else if (section == kAdTipsClassroomSection) {
            NSArray *adList = [self.adContent objectForKey:kAdTipsClassroom];
            // 增加 空白行
            return adList.count > 0?2:0;
        }  else if (section == kStrategySection) {
            //买货攻略 增加 空白行
            return self.strategyTipsList.count > 0?2:0;
        } else if (section == kAdTipsStrategySection) {
            NSArray *adList = [self.adContent objectForKey:kAdTipsStrategy];
            // 增加 空白行
            return adList.count > 0?2:0;
        } else if (section == kTipsTopicSection) {
            return self.tipsTopicList.count;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableViewSelected) {
        //精选
        // 0-轮播图,导航入口 1-活动入口 2-装修案例
        if (indexPath.section == kBannerSection) {
            if (indexPath.row == 0) {
                return [HomeBannerTableViewCell heightByType:0];
            }
        } else if (indexPath.section == kAdSection || indexPath.section == kAdSelectedZxSection) {
            if (indexPath.row == 0) {
                return kScreenWidth * 180 / 750;
            }
        } else if (indexPath.section == kActivitySection) {
            if (indexPath.row == 0) {
                return [HomeActivityTableViewCell getHeightForDevice];
            }
        } else if (indexPath.section == kExampleSection) {
            if (indexPath.row < self.exampleSelectedList.count) {
                return [HomeExampleTableViewCell getHeightForRow:indexPath.row Count:self.exampleSelectedList.count];
            }
        } else if (indexPath.section  == kSelectedTopicSection) {
            if(indexPath.row == 0){
                return [GoodSelectTableViewCell getHeightForDevice:NO];
            }else{
                return [GoodSelectTableViewCell getHeightForDevice:YES];
            }
        }
    } else {
        //攻略
        // 0-轮播图,装修知识 1-家芭莎课堂 2-买货攻略
        if (indexPath.section == kBannerSection) {
            if (indexPath.row == 0) {
                return [HomeBannerTableViewCell heightByType:1];
            }
        } else if (indexPath.section == kAdTipsKnowledgeSection || indexPath.section == kAdTipsClassroomSection
                   || indexPath.section == kAdTipsStrategySection) {
            if (indexPath.row == 0) {
                return kScreenWidth * 180 / 750;
            }
        } else if (indexPath.section == kClassroomSection) {
            if (indexPath.row == 0) {
                return 192;
            }
            
        }  else if (indexPath.section == kStrategySection) {
            if (indexPath.row == 0) {
                return 170;
            }
        } else if (indexPath.section == kTipsTopicSection) {
            //热门话题
            if (indexPath.row == 0) {
                return 45 + (kScreenWidth - 20)*310/710 + 10;
            } else {
                return (kScreenWidth - 20)*310/710 + 10;
            }
        }
    }
    
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tableViewSelected) {
        //精选
        if (indexPath.section == kBannerSection) {
            // 轮播图,导航入口
            if (indexPath.row == 0) {
                return [self bannerCellForTableView:tableView];
            }
        } else if (indexPath.section == kAdSection) {
            // 广告
            if (indexPath.row == 0) {
                return [self adCellForTableView:tableView name:kAdSelectedActivity];
            }
        } else if (indexPath.section == kActivitySection) {
             // 活动入口
            if (indexPath.row == 0) {
                return [self activityCellForTableView:tableView];
            }
        } else if (indexPath.section == kExampleSection) {
             // 装修案例
            if (indexPath.row < self.exampleSelectedList.count) {
                return [self exampleCellForTableView:tableView IndexPath:indexPath];
            }
        } else if (indexPath.section == kAdSelectedZxSection) {
            // 广告
            if (indexPath.row == 0) {
                return [self adCellForTableView:tableView name:kAdSelectedZx];
            }
        } else if (indexPath.section  == kSelectedTopicSection) {
            //发现好家
            return [self GoodSelectCellForTableView:tableView cellForRowAtIndexPath:indexPath];
        }
    } else {
        //攻略
        // 0-轮播图,装修知识 1-家芭莎课堂 2-买货攻略
        if (indexPath.section == kBannerSection) {
            if (indexPath.row == 0) {
                return [self bannerCellForTableViewTips:tableView];
            }
        } else if (indexPath.section == kAdTipsKnowledgeSection) {
            // 广告
            if (indexPath.row == 0) {
                return [self adCellForTableView:tableView name:kAdTipsKnowledge];
            }
        } else if (indexPath.section == kClassroomSection) {
            if (indexPath.row == 0) {
                return [self classroomCellForTableViewTips:tableView];
            }
        } else if (indexPath.section == kAdTipsClassroomSection) {
            // 广告
            if (indexPath.row == 0) {
                return [self adCellForTableView:tableView name:kAdTipsClassroom];
            }
        }  else if (indexPath.section == kStrategySection) {
            if (indexPath.row == 0) {
                return [self strategyCellForTableViewTips:tableView];
            }
        } else if (indexPath.section == kAdTipsStrategySection) {
            // 广告
            if (indexPath.row == 0) {
                return [self adCellForTableView:tableView name:kAdTipsStrategy];
            }
        } else if (indexPath.section == kTipsTopicSection) {
            //热门话题
            return [self tipsTopicTableViewCell:tableView IndexPath:indexPath];
            
        }
    }

    //空白行
    return [self spaceCellForTableView:tableView];
}

//空白行
- (UITableViewCell *)spaceCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"SpaceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.contentView.backgroundColor = RGBFromHexColor(0xf4f4f4);
    return cell;
}

//精选-轮播图
- (UITableViewCell *)bannerCellForTableView:(UITableView *)tableView {
    
    HomeBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeBannerTableViewCell"];
    
    [cell.viewBanner removeAllSubviews];
    [cell.scrollView removeAllSubviews];
    
    NSMutableArray *urls = [NSMutableArray arrayWithCapacity:self.bannerSelectedList.count];
    for (Banner *banner in self.bannerSelectedList) {
        if (banner.contentPicUrl) {
            [urls addObject:banner.contentPicUrl];
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
        LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 360 / 750)
                                                            delegate:self
                                                           imageURLs:urls
                                                placeholderImageName:@"正大"
                                                        timeInterval:time
                                       currentPageIndicatorTintColor:[UIColor colorWithHexString:@"#601986"]
                                              pageIndicatorTintColor:[UIColor colorWithHexString:@"#aaa49e"]];
        bannerView.tag = 0;
        //self.bannerView2 = bannerView;
        [cell.viewBanner addSubview:bannerView];
    }
    
    //导航入口
    CGFloat _pad = (kScreenWidth - 20 - self.categorySelectedList.count * 50) / 4;
    for (int i = 0; i < self.categorySelectedList.count; i++) {
        CategorySelected *category = [self.categorySelectedList objectAtIndex:i];
        
        HomeContentView *categoryView = [HomeContentView instanceActiveView];
        categoryView.frame = CGRectMake(10 + (50 + _pad) * i, 0, 50, 81);
        
        UIImage *placeImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@home", category.contentTile ]];
        if (placeImage == nil) {
            placeImage = [UIImage imageNamed:@"正小"];
        }
        
        //图片
        [categoryView.imgViewAct sd_setImageWithURL:[NSURL URLWithString:category.contentPicUrl] placeholderImage:placeImage];
        categoryView.labelActName.text = category.contentTile;
        categoryView.controlAct.tag = i;
        [categoryView.controlAct addTarget:self action:@selector(categoryClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.scrollView addSubview:categoryView];
    }
//    cell.scrollView.contentSize = CGSizeMake(70 * self.categorySelectedList.count, 81);
    cell.scrollView.contentSize = CGSizeMake(kScreenWidth, 81);
    
    return cell;
}

//精选-广告
- (UITableViewCell *)adCellForTableView:(UITableView *)tableView name:(NSString *)name {
    
    static NSString *CellIdentifier = @"adCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    DSButton *button = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        button = [DSButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 180 / 750);
        button.tag = 999;
        [cell.contentView addSubview:button];
    } else {
        button = [cell.contentView viewWithTag:999];
    }
    
    NSArray *adList = [self.adContent objectForKey:name];
    if (adList.count == 0) {
        return cell;
    }
    AdContent *ad = [adList objectAtIndex:0];
    [button sd_setBackgroundImageWithURL:[NSURL URLWithString:ad.contentPicUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"长方形"]];
    button.name = ad.adLocationEname;
    [button addTarget:self action:@selector(adContentPicClicked:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

//精选-活动入口
- (UITableViewCell *)activityCellForTableView:(UITableView *)tableView {
    
    HomeActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeActivityTableViewCell"];
    
    NSArray *imgViews = @[cell.imgView1, cell.imgView2, cell.imgView3, cell.imgView4];
    for (int i = 0; i < imgViews.count; i++) {
        UIImageView *imageView = [imgViews objectAtIndex:i];
        imageView.tag = i;
        [self removeGestureRecognizer:imageView];
        
        if ( i< self.activitySelectedList.count) {
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activityTapGesture:)];
            [imageView addGestureRecognizer:tapGesture];
            
            Activity *activity = [self.activitySelectedList objectAtIndex:i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:activity.contentPicUrl]];
            
        } else {
            imageView.image = nil;
        }
    }

    return cell;
}

//精选-装修案例
- (UITableViewCell *)exampleCellForTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath {
    
    HomeExampleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeExampleTableViewCell"];
    
    if (self.exampleSelectedList.count == 1) {
        cell.viewHead.hidden = NO;
        cell.heightForHead.constant = 50.0;
        cell.controlMore.hidden = NO;

    } else if (indexPath.row == 0) {
        cell.viewHead.hidden = NO;
        cell.heightForHead.constant = 50.0;
        cell.controlMore.hidden = YES;
        
    } else if (indexPath.row == self.exampleSelectedList.count - 1) {
        cell.viewHead.hidden = YES;
        cell.heightForHead.constant = 0.0;
        cell.controlMore.hidden = NO;
        
    } else {
        cell.viewHead.hidden = YES;
        cell.heightForHead.constant = 0.0;
        cell.controlMore.hidden = YES;
    }
    
    Example *example = [self.exampleSelectedList objectAtIndex:indexPath.row];
    cell.labelTitle.text = @"装修案例";
    [cell.imgViewPic sd_setImageWithURL:[NSURL URLWithString:example.showImgUrl] placeholderImage:[UIImage imageNamed:@"长方形"]];
    [cell.imgViewLogo sd_setImageWithURL:[NSURL URLWithString:example.storeLogo] placeholderImage:[UIImage imageNamed:@"正小"]];
    
    cell.labelExName.text = example.exampleName;
    cell.labelStoreName.text = example.storeName;
    cell.labelText.text = example.exampleText;
    
    [cell.controlEx addTarget:self action:@selector(exampleClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.controlEx.tag = indexPath.row;
    
    if (cell.controlMore.hidden == NO) {
        //查看所有案例
        [cell.controlMore addTarget:self action:@selector(showAllExampleClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

//精选-发现好家
- (UITableViewCell *) GoodSelectCellForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodSelectTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == 0){
        cell.labelTopTitle.text = @"发现好家";
        cell.viewHeaderHeight.constant = 46;
    }else{
        cell.viewHeaderHeight.constant = 15;
    }
    
    if(indexPath.row == (self.selectedTopicList.count - 1)){
        cell.viewLine.hidden = YES;;
    }else{
        cell.viewLine.hidden = NO;;
    }
    
    RenovationTopic *topic = _selectedTopicList[indexPath.row];
    [cell.imageViewBig sd_setImageWithURL:[NSURL URLWithString:topic.topicPicUrl] placeholderImage:[UIImage imageNamed:RECTPLACEHOLDERIMG]];
    
    [self removeGestureRecognizer:cell.imageViewBig];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodhomeTapGesture:)];
    cell.imageViewBig.userInteractionEnabled = YES;
    cell.imageViewBig.tag = indexPath.row;
    [cell.imageViewBig addGestureRecognizer:tapGesture];
    
    NSArray *product = [NSArray arrayWithArray:topic.product];
    NSArray *imgViews = @[cell.imageViewSmall1, cell.imageViewSmall2, cell.imageViewSmall3];
    NSArray *labels = @[cell.labelTitle1, cell.labelTitle2, cell.labelTitle3];
    NSArray *labelPrices = @[cell.labelPrice1, cell.labelPrice2, cell.labelPrice3];
    NSArray *btnJumps = @[cell.btnJump1, cell.btnJump2, cell.btnJump3];
    for (int i = 0; i < product.count && i< 3; i++) {
        NSDictionary *productDic = product[i];
        UIImageView *imageView = [imgViews objectAtIndex:i];
        UILabel *label = [labels objectAtIndex:i];
        UILabel *labelPrice = [labelPrices objectAtIndex:i];
        UILabel *btnJump = [btnJumps objectAtIndex:i];
        imageView.tag = i;
        btnJump.hidden = YES;
        imageView.superview.tag = indexPath.row;
        [self removeGestureRecognizer:imageView];
        if (productDic != nil) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodhomeProductTapGesture:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tapGesture];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[productDic[@"img_url"] description]] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
            label.text = [productDic[@"product_name"] description];
            
            if (productDic[@"mall_price"]) {
                labelPrice.text = [NSString stringWithFormat:@"惊爆价:￥%@",[productDic[@"mall_price"] description]];
            } else {
                labelPrice.text = @"面议";
            }
            
            imageView.hidden = NO;
            label.hidden = NO;
            labelPrice.hidden = NO;
        }else{
            imageView.image = nil;
            label.text = @"";
        }
    }
    
    NSInteger num = product.count;
    for (int i = (int)num; i < 3 ; i++) {
        UIImageView *imageView = [imgViews objectAtIndex:i];
        UILabel *label = [labels objectAtIndex:i];
        UILabel *labelPrice = [labelPrices objectAtIndex:i];
        UIButton *btnJump = [btnJumps objectAtIndex:i];
        imageView.hidden = YES;
        label.hidden = YES;
        labelPrice.hidden = YES;
        btnJump.hidden  = YES;
    }
    
    return cell;
}

//攻略-轮播图
- (UITableViewCell *)bannerCellForTableViewTips:(UITableView *)tableView {
    
    HomeBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeBannerTableViewCell"];
    
    [cell.viewBanner removeAllSubviews];
    [cell.scrollView removeAllSubviews];
    cell.viewKnow.hidden = NO;
    cell.leftForScrollView.constant = 70;
    
    NSMutableArray *urls = [NSMutableArray arrayWithCapacity:self.bannerTipsList.count];
    for (Banner *banner in self.bannerTipsList) {
        if (banner.contentPicUrl) {
            [urls addObject:banner.contentPicUrl];
        }
    }
    
    if (urls.count > 0) {
        //轮播图
        LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 360 / 750)
                                                            delegate:self
                                                           imageURLs:urls
                                                placeholderImageName:@"正大"
                                                        timeInterval:2.0f
                                       currentPageIndicatorTintColor:[UIColor colorWithHexString:@"#601986"]
                                              pageIndicatorTintColor:[UIColor colorWithHexString:@"#aaa49e"]];
        bannerView.tag = 1;
        [cell.viewBanner addSubview:bannerView];
    }
    
    //装修知识
    cell.viewKnow.hidden = NO;
    for (int i = 0; i < self.knowledgeTipsList.count; i++) {
        Knowledge *knowledge = [self.knowledgeTipsList objectAtIndex:i];
        
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0 + (5 + 80) * i, 10, 80, 68)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:control.bounds];
        [imageView sd_setImageWithURL:[NSURL URLWithString:knowledge.contentPicUrl] placeholderImage:[UIImage imageNamed:@"正小"]];
        [control addSubview:imageView];
        
//        UILabel *label = [[UILabel alloc] initWithFrame:control.bounds];
//        label.textColor = [UIColor whiteColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [UIFont systemFontOfSize:15];
//        label.text = knowledge.contentTile;
//        label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
//        [control addSubview:label];

        control.tag = i;
        [control addTarget:self action:@selector(knowledgeClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.scrollView addSubview:control];
    }

    cell.scrollView.contentSize = CGSizeMake(15 + (5 + 80) * self.knowledgeTipsList.count, 81);
    
    return cell;
}

//家芭莎课堂
- (UITableViewCell *)classroomCellForTableViewTips:(UITableView *)tableView {
    
    ClassroomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassroomTableViewCell"];

    cell.labelTitle.text = @"家芭莎课堂";
    [cell.scrollView removeAllSubviews];
    cell.imageViewLogo.hidden = NO;
    cell.leftToImage.priority = UILayoutPriorityDefaultHigh;
    cell.leftToSuper.priority = UILayoutPriorityDefaultLow;
    
    for (int i = 0; i < self.classroomTipsList.count; i++) {
        Classroom *classroom = [self.classroomTipsList objectAtIndex:i];
        
        HomeContentView *classroomView = [HomeContentView instanceClassRoomView];
        classroomView.frame = CGRectMake(10 + (6 + 113) * i, 0, 113, 128);
    
        [classroomView.imgViewClassRoom sd_setImageWithURL:[NSURL URLWithString:classroom.contentPicUrl]];
        classroomView.labelClassRoom.text = classroom.contentTile;
        
        classroomView.controlClassRoom.tag = i;
        [classroomView.controlClassRoom addTarget:self action:@selector(classroomClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.scrollView addSubview:classroomView];
    }
    
    cell.scrollView.contentSize = CGSizeMake(14 + (6 + 113) * self.classroomTipsList.count, 142);
    
    return cell;
}

//买货攻略
- (UITableViewCell *)strategyCellForTableViewTips:(UITableView *)tableView {
    
    ClassroomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassroomTableViewCell"];
    
    cell.labelTitle.text = @"买货攻略";
    [cell.scrollView removeAllSubviews];
    cell.imageViewLogo.hidden = YES;
    cell.leftToImage.priority = UILayoutPriorityDefaultLow;
    cell.leftToSuper.priority = UILayoutPriorityDefaultHigh;
    
    for (int i = 0; i < self.strategyTipsList.count; i++) {
        Strategy *strategy = [self.strategyTipsList objectAtIndex:i];
        
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(10 + (6 + 105) * i, 0, 105, 105)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:control.bounds];
        [imageView sd_setImageWithURL:[NSURL URLWithString:strategy.contentPicUrl]];
        [control addSubview:imageView];
        
//        UILabel *label = [[UILabel alloc] initWithFrame:control.bounds];
//        label.textColor = [UIColor whiteColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [UIFont systemFontOfSize:15];
//        label.text = strategy.contentTile;
//        [control addSubview:label];
        
        control.tag = i;
        [control addTarget:self action:@selector(strategyClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.scrollView addSubview:control];
    }
    
    cell.scrollView.contentSize = CGSizeMake(14 + (6 + 105) * self.strategyTipsList.count, 81);
    
    return cell;
}

//热门话题
- (UITableViewCell *)tipsTopicTableViewCell:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    
    RenovationTopic *topic = _tipsTopicList[indexPath.row];

    if (indexPath.row == 0) {
        HomeContentView *contentView = [HomeContentView instanceTitleView];
        contentView.frame = CGRectMake(0, 0, kScreenWidth, 45);
        contentView.labelTitle.text = @"热门话题";
        [cell.contentView addSubview:contentView];
    }
    
    CGRect rect = CGRectMake(10, indexPath.row==0?45:0, kScreenWidth - 20, (kScreenWidth - 20)*310/710);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:topic.topicPicUrl] placeholderImage:[UIImage imageNamed:RECTPLACEHOLDERIMG]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipsTopicTapGesture:)];
    imageView.userInteractionEnabled = YES;
    imageView.tag = indexPath.row;
    [imageView addGestureRecognizer:tapGesture];
    [cell.contentView addSubview:imageView];

    return cell;
}

#pragma mark - Actions LCBannerViewDelegate
//轮播图点击
- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    Banner *banner = nil;
    if (bannerView.tag == 0) {
        banner = [self.bannerSelectedList objectAtIndex:index];
    } else {
        banner = [self.bannerTipsList objectAtIndex:index];
    }
    
    [self openWebView:banner.contentUrl];
}

#pragma mark - Actions
//城市切换
- (IBAction)btnLocationClicked:(id)sender {
    SwitchCityViewController *viewController = [[SwitchCityViewController alloc] initWithNibName:@"SwitchCityViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

//检索
- (IBAction)searchClicked:(id)sender {
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

//扫码
- (IBAction)saomaClicked:(id)sender {
    ScanViewController *view = [[ScanViewController alloc]  initWithNibName:@"ScanViewController" bundle:nil];
    [self.navigationController pushViewController:view animated:YES];
}

//精选 攻略 切换
- (IBAction)btnSelectedTipsClicked:(UIButton *)sender {
    if (sender == _btnSelected) {
        if (self.selectPage == 0) {
            //刷新
        } else {
            self.selectPage = 0;
            _tableViewSelected.hidden = NO;
            _tableViewTips.hidden = YES;
            
            [_btnSelected setSelected:YES];
            [_btnTips setSelected:NO];
            
            [UIView animateWithDuration:.3 animations:^{
                _leftViewline.constant = 17;
            }];
            
            //第一次刷新 攻略 数据
            if (_btnSelected.tag == 0) {
                _btnSelected.tag = 1;
                [_tableViewSelected.mj_header beginRefreshing];
            }
        }
    } else if (sender == _btnTips) {
        if (self.selectPage == 1) {
            //刷新
        } else {
            self.selectPage = 1;
            _tableViewSelected.hidden = YES;
            _tableViewTips.hidden = NO;
            
            [_btnSelected setSelected:NO];
            [_btnTips setSelected:YES];
            
            [UIView animateWithDuration:.3 animations:^{
                _leftViewline.constant = 17 + 55;
            }];
            
            //第一次刷新 攻略 数据
            if (_btnTips.tag == 0) {
                _btnTips.tag = 1;
                [_tableViewTips.mj_header beginRefreshing];
            }
        }
    }
}

//导航入口点击事件
- (void)categoryClicked:(UIControl *)control {
    CategorySelected *category = [self.categorySelectedList objectAtIndex:control.tag];
    
    NSString *urlString = category.contentUrl;
    
    if ([@"jbs://hot_activities/" isEqualToString:urlString]) {
        //热门活动
        ActivityListViewController *viewContoller = [[ActivityListViewController alloc] init];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://order_design/" isEqualToString:urlString]) {
        //预约设计
        AppointDesignViewController *viewContoller = [[AppointDesignViewController alloc] init];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://decorate_assistant/" isEqualToString:urlString]) {
        //装修助手
        DecorateViewController *viewContoller = [[DecorateViewController alloc] init];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://cash_ticket/" isEqualToString:urlString]) {
        //现金券
        CouponViewController *viewContoller = [[CouponViewController alloc] init];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://cabinet_electric/" isEqualToString:urlString]) {
        //橱柜厨电
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = [category.contentTile description];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://bathroom_accessory_ceramic/" isEqualToString:urlString]) {
        //卫浴陶瓷
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = [category.contentTile description];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://floor_board_windows/" isEqualToString:urlString]) {
        //地板门窗
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = [category.contentTile description];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://house_furniture/" isEqualToString:urlString]) {
        //住宅家具
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = [category.contentTile description];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://furniture_soft_decoration/" isEqualToString:urlString]) {
        //家居软装
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = [category.contentTile description];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://base_building_materials/" isEqualToString:urlString]) {
        //基础建材
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = [category.contentTile description];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://big_household_appliances/" isEqualToString:urlString]) {
        //大家电
        RenovationCategoryViewController *viewContoller = [[RenovationCategoryViewController alloc] init];
        viewContoller.strStyle = [category.contentTile description];
        [self.navigationController pushViewController:viewContoller animated:YES];
        
    } else if ([@"jbs://decorate_company/" isEqualToString:urlString]) {
        //装修公司
        AppDelegate *appDelegate = APP_DELEGATE;
        [appDelegate.MyTabBarController controlBuildingMaterialClick];
        
    } else if ([@"jbs://login/" isEqualToString:urlString]) {
        //登陆
        [[NSNotificationCenter defaultCenter] postNotificationName:@"needlogin" object:nil];
        
    } else if ([@"jbs://home/" isEqualToString:urlString]) {
        //首页
        //AppDelegate *appDelegate = APP_DELEGATE;
        //[appDelegate.MyTabBarController controlHomeClick];
        
    } else if ([@"jbs://mine/" isEqualToString:urlString]) {
        //我的
        AppDelegate *appDelegate = APP_DELEGATE;
        [appDelegate.MyTabBarController controlMyClick];
        
    } else if ([@"jbs://message/" isEqualToString:urlString]) {
        //消息中心
        if (DATA_ENV.isLogin) {
            MessageViewController* messageController = [[MessageViewController alloc]init];
            [self.navigationController pushViewController:messageController animated:YES];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"needlogin" object:nil];
        }
    } else {
        [self openWebView:category.contentUrl];
    }
}

//广告点击入口
- (void)adContentPicClicked:(DSButton *)button {
    NSArray *adList = [self.adContent objectForKey:button.name];
    if (adList.count == 0) {
        NSLog(@"广告点击 数据错误0");
        return;
    }
    AdContent *ad = [adList objectAtIndex:0];
    [self openWebView:ad.contentUrl];
}

//活动点击事件
- (void)activityTapGesture:(UITapGestureRecognizer *)tapGesture {
    UIView *view = tapGesture.view;
    
    Activity *activity = [self.activitySelectedList objectAtIndex:view.tag];
    [self openWebView:activity.contentUrl];
}

//案例点击
- (void)exampleClicked:(UIControl *)control {

    //案例
    Example *example = [self.exampleSelectedList objectAtIndex:control.tag];
    CaseHomeViewController *view = [[CaseHomeViewController alloc] initWithNibName:@"CaseHomeViewController" bundle:nil];
    view.albumId = example.albumId;
    [self.navigationController pushViewController:view animated:YES];
}

//查看所有案例
- (void)showAllExampleClicked:(UIControl *)control {
    //装修公司案例
    AppDelegate *appDelegate = APP_DELEGATE;
    appDelegate.allExample = @"1";
    [appDelegate.MyTabBarController controlBuildingMaterialClick];
}

//装修知识点击事件
- (void)knowledgeClicked:(UIControl *)control {
    Knowledge *knowledge = [self.knowledgeTipsList objectAtIndex:control.tag];
    [self openWebView:knowledge.contentUrl];
}

//家芭莎课堂点击事件
- (void)classroomClicked:(UIControl *)control {
    Classroom *classroom = [self.classroomTipsList objectAtIndex:control.tag];
    [self openWebView:classroom.contentUrl];
}

//买货攻略点击事件
- (void)strategyClicked:(UIControl *)control {
    Strategy *strategy = [self.strategyTipsList objectAtIndex:control.tag];
    [self openWebView:strategy.contentUrl];
}

//发现好家
- (void)goodhomeTapGesture:(UITapGestureRecognizer *)tapGesture {
    RenovationTopic *renovationTopic = _selectedTopicList[tapGesture.view.tag];
    [self openWebView:renovationTopic.topicUrl];
}

//发现好家-商品
- (void)goodhomeProductTapGesture:(UITapGestureRecognizer *)tapGesture {
    RenovationTopic *renovationTopic = _selectedTopicList[tapGesture.view.superview.tag];
    NSDictionary *productDic = renovationTopic.product[tapGesture.view.tag];
    
//    //团
//    if (goodsDetail.tuan && [goodsDetail.tuan[@"tuaning"] boolValue] == YES) {
//        GroupProductDetailViewController *viewControler = [[GroupProductDetailViewController alloc] init];
//        viewControler.productId = goodsDetail.productId;
//        [self.navigationController pushViewController:viewControler animated:YES];
//    } else {
        RenovationShopDetialViewController *viewControler = [[RenovationShopDetialViewController alloc] init];
        viewControler.productId = productDic[@"product_id"];
        [self.navigationController pushViewController:viewControler animated:YES];
//    }
    
}

//热门话题
- (void)tipsTopicTapGesture:(UITapGestureRecognizer *)tapGesture {
    RenovationTopic *renovationTopic = _tipsTopicList[tapGesture.view.tag];
    [self openWebView:renovationTopic.topicUrl];
}

#pragma mark - private
//取广告数据  //type 0-精选 1-攻略
- (void)getAdContent:(NSString *)name type:(NSInteger)type {
    __weak typeof(self) weakSelf = self;
    [GetContentRequest requestWithParameters:@{@"ad_location_name":name}
                               withCacheType:DataCacheManagerCacheTypeMemory
                           withIndicatorView:nil
                           withCancelSubject:[GetContentRequest getDefaultRequstName]
                              onRequestStart:nil
                           onRequestFinished:^(CIWBaseDataRequest *request) {
                               if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                   
                                   if ([request.resultDic objectForKey:KEY_ADCONTENT]) {
                                       [weakSelf.adContent setObject:[request.resultDic objectForKey:KEY_ADCONTENT] forKey:name];
                                   } else {
                                       [weakSelf.adContent removeObjectForKey:name];
                                   }
                                       
                                   if (type == 0) {
                                       [_tableViewSelected reloadData];
                                   } else {
                                       [_tableViewTips reloadData];
                                   }
                               }
                           }
                           onRequestCanceled:^(CIWBaseDataRequest *request) {
                               //[_tableViewSelected.mj_header endRefreshing];
                           }
                             onRequestFailed:^(CIWBaseDataRequest *request) {
                                 //[_tableViewSelected.mj_header endRefreshing];
                             }];
    
}

//取精选数据
- (void)getSelectedData {
    
    __weak typeof(self) weakSelf = self;
    [GetHomeSelectedRequest requestWithParameters:nil
                                    withCacheType:DataCacheManagerCacheTypeMemory
                                withIndicatorView:nil
                                withCancelSubject:[GetHomeSelectedRequest getDefaultRequstName]
                                   onRequestStart:nil
                                onRequestFinished:^(CIWBaseDataRequest *request) {
                                    
                                    if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                        
                                        weakSelf.bannerSelectedList = [request.resultDic objectForKey:@"banner"];
                                        weakSelf.categorySelectedList = [request.resultDic objectForKey:@"category"];
                                        weakSelf.activitySelectedList = [request.resultDic objectForKey:@"activity"];
                                        weakSelf.exampleSelectedList = [request.resultDic objectForKey:@"example"];
                                        
                                        [_tableViewSelected reloadData];
                                    }
                                    
                                    [_tableViewSelected.mj_header endRefreshing];
                                }
                                onRequestCanceled:^(CIWBaseDataRequest *request) {
                                    [_tableViewSelected.mj_header endRefreshing];
                                }
                                onRequestFailed:^(CIWBaseDataRequest *request) {
                                    [_tableViewSelected.mj_header endRefreshing];
                                }];
    
    //精选广告
    [self getAdContent:kAdSelectedActivity type:0];
    [self getAdContent:kAdSelectedZx type:0];
    
    //专题-发现好家
    [self getTopicList:@"HOME_SELECTED" product:@"1"];
}

//取攻略数据
- (void)getTipsData {
    
    __weak typeof(self) weakSelf = self;
    [GetHomeTipsRequest requestWithParameters:nil
                                    withCacheType:DataCacheManagerCacheTypeMemory
                                withIndicatorView:nil
                                withCancelSubject:[GetHomeTipsRequest getDefaultRequstName]
                                   onRequestStart:nil
                                onRequestFinished:^(CIWBaseDataRequest *request) {
                                    
                                    if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                        
                                        weakSelf.bannerTipsList = [request.resultDic objectForKey:@"banner"];
                                        weakSelf.knowledgeTipsList = [request.resultDic objectForKey:@"knowledge"];
                                        weakSelf.classroomTipsList = [request.resultDic objectForKey:@"classroom"];
                                        weakSelf.strategyTipsList = [request.resultDic objectForKey:@"strategy"];
                                        
                                        [_tableViewSelected reloadData];
                                    }
                                    
                                    [_tableViewTips.mj_header endRefreshing];
                                }
                                onRequestCanceled:^(CIWBaseDataRequest *request) {
                                    [_tableViewTips.mj_header endRefreshing];
                                }
                                onRequestFailed:^(CIWBaseDataRequest *request) {
                                    [_tableViewTips.mj_header endRefreshing];
                                }];
    
    //攻略广告
    [self getAdContent:kAdTipsKnowledge type:1];
    [self getAdContent:kAdTipsClassroom type:1];
    [self getAdContent:kAdTipsStrategy type:1];
    
    //专题 - 热门话题
    [self getTopicList:@"HOME_TIPS" product:@"0"];
}

//专题推荐
- (void)getTopicList:(NSString *)type product:(NSString *)product{
    __weak typeof(self) weakSelf = self;
    [GetRenovationTopicRequest requestWithParameters:@{@"type":type, @"product":product}
                                       withCacheType:DataCacheManagerCacheTypeMemory
                                   withIndicatorView:nil
                                   withCancelSubject:[GetRenovationTopicRequest getDefaultRequstName]
                                      onRequestStart:nil
                                   onRequestFinished:^(CIWBaseDataRequest *request) {
                                       
                                       if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                
                                           if ([type isEqualToString:@"HOME_SELECTED"]) {
                                               weakSelf.selectedTopicList = [request.resultDic objectForKey:@"topic"];
                                               [_tableViewSelected reloadData];
                                           } else {
                                               weakSelf.tipsTopicList = [request.resultDic objectForKey:@"topic"];
                                               [_tableViewTips reloadData];
                                           }
                                       }
                                   }
                                   onRequestCanceled:^(CIWBaseDataRequest *request) {
                                   }
                                     onRequestFailed:^(CIWBaseDataRequest *request) {
                                     }];
}

- (void)openWebView:(NSString *)urlstring {
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewController.urlString = urlstring;
    [self.navigationController pushViewController:webViewController animated:YES];
}

//移除手势
- (void)removeGestureRecognizer:(UIView *)aView
{
    NSArray *allGesture = aView.gestureRecognizers;
    for (UIGestureRecognizer *gesture in allGesture) {
        [aView removeGestureRecognizer:gesture];
    }
}

@end
