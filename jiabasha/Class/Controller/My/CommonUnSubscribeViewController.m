//
//  CommonUnSubscribeViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/5.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "CommonUnSubscribeViewController.h"
#import "ConmmonUnSubscibeTableViewCell.h"
#import "GetCommonTopicList.h"
#import "CommonTopicModel.h"
#import "CommonWebViewController.h"

@interface CommonUnSubscribeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) NSMutableArray *arrChoiceness;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@end

@implementation CommonUnSubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    [self getCommonList];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 165;
    [_tableView registerNib:[UINib nibWithNibName:@"ConmmonUnSubscibeTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cellunsubscrib"];
    //设置tableview顶部视图
    _viewHeader.frame = CGRectMake(0, 0, kScreenWidth, 204);
    _tableView.tableHeaderView = _viewHeader;
    _labelTitle.text = _titleTop;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy init
- (NSMutableArray *)arrChoiceness
{
    if (_arrChoiceness == nil) {
        _arrChoiceness = [NSMutableArray array];
    }
    return _arrChoiceness;
}

#pragma mark - Request

- (void)getCommonList{
/*
 "city_id": "110900","type":"HOME_SELECTED","product":"0","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
 */
    __weak typeof(self)weakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"MY",@"type",@"0",@"product", nil];
    [GetCommonTopicList requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[GetCommonTopicList getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            weakSelf.arrChoiceness = [request.resultDic objectForKey:@"topicArr"];
            [weakSelf.tableView reloadData];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrChoiceness.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonTopicModel *topicModel = (CommonTopicModel *)[self.arrChoiceness objectAtIndex:indexPath.row];
    ConmmonUnSubscibeTableViewCell *cellUnsubscrib = [tableView dequeueReusableCellWithIdentifier:@"Cellunsubscrib"];
    [cellUnsubscrib.imageCover sd_setImageWithURL:[NSURL URLWithString:topicModel.topicPicUrl] placeholderImage:[UIImage imageNamed:NORMALPLACEHOLDERIMG]];
    cellUnsubscrib.selectionStyle = UITableViewCellSelectionStyleNone;
    return cellUnsubscrib;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonTopicModel *topicModel = (CommonTopicModel *)[self.arrChoiceness objectAtIndex:indexPath.row];
    NSDictionary *modelDic = [NSDictionary dictionaryWithObjectsAndKeys:topicModel.topicUrl,@"url", nil];
    if ([_superType isEqualToString:@"display"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"responseForDicplaySubscribe" object:nil userInfo:modelDic];
    } else {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"responseForStoreSubscribe" object:nil userInfo:modelDic];
    }
    
}

//#pragma mark - ButtonClick
//- (IBAction)goBack:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}


@end
