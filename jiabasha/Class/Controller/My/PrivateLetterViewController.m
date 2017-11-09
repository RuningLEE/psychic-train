//
//  PrivateLetterViewController.m
//  jiabasha
//
//  Created by zhangzt on 2016/12/30.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "PrivateLetterViewController.h"
#import "SystemNoticeTableViewCell.h"
#import "ChatListViewController.h"
#import "GetLetterListRequest.h"
#import "Letter.h"
#import "MessageUser.h"

@interface PrivateLetterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* arrLetter;
@property (assign, nonatomic) int page;
@property (assign, nonatomic, getter=isRefreshing) BOOL refreshing;
@end

@implementation PrivateLetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置tableview
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 72;
    _tableView.backgroundColor = RGB(246, 246, 246);
    //添加刷新组件
    [self addRefreshing];
    //准备刷新
    [_tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)arrLetter
{
    if (_arrLetter == nil) {
        _arrLetter = [[NSMutableArray alloc]init];
    }
    return _arrLetter;
}

//添加刷新
- (void)addRefreshing{
    //添加下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        _refreshing = YES;
        [self getLetterListRequest];
    }];
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    //添加上拉刷新
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _refreshing = NO;
        [self getLetterListRequest];
    }];
}

#pragma mark - Request
- (void)getLetterListRequest{
    /*
     {"uid": "4561250","page":"0","size":"20","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:DATA_ENV.userInfo.user.uid,@"uid",[NSString stringWithFormat:@"%d",_page],@"page",PAGESIZE,@"size", nil];
    [GetLetterListRequest requestWithParameters:param withCacheType:0 withIndicatorView:nil withCancelSubject:[GetLetterListRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([RESPONSE_OK isEqualToString:request.errCode]) {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            NSArray *reslutArray = [request.resultDic objectForKey:@"arrLetterModel"];
            if ([reslutArray count] < 20) {
                _tableView.mj_footer.hidden = YES;
            } else {
                _tableView.mj_footer.hidden = NO;
                _page++;
            }
            if ([weakSelf isRefreshing] == YES) {//下拉
                [weakSelf.arrLetter removeAllObjects];
                weakSelf.arrLetter = [NSMutableArray arrayWithArray:[request.resultDic objectForKey:@"arrLetterModel"]];
                [weakSelf.tableView reloadData];
            }else{//上拉
                [weakSelf.arrLetter addObjectsFromArray:[NSMutableArray arrayWithArray:[request.resultDic objectForKey:@"arrLetterModel"]]];
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

#pragma mark - TableViewaDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrLetter.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemNoticeTableViewCell *systemCell = [[SystemNoticeTableViewCell alloc]initWithTableView:tableView];
    systemCell.letterModel = (Letter *)[self.arrLetter objectAtIndex:indexPath.row];
    return systemCell;
}

#pragma mark - TableView Delegate 
//回调设置某行是否当被点击后处于高亮状态
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//回调当某行处于高亮状态时的行为
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemNoticeTableViewCell* systemcell = [tableView cellForRowAtIndexPath:indexPath];
    systemcell.backgroundColor = RGB(252, 245, 255);
}
//回调当某行失去高亮状态时的行为
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemNoticeTableViewCell* systemcell = [tableView cellForRowAtIndexPath:indexPath];
    systemcell.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Letter *letterModel = (Letter *)[self.arrLetter objectAtIndex:indexPath.row];
    ChatListViewController *chatController = [[ChatListViewController alloc]init];
    chatController.toId = letterModel.toUser.uid;
    if ([letterModel.toUser.uid isEqualToString:DATA_ENV.userInfo.user.uid]) {
        chatController.toUser = letterModel.fromUser;
    } else {
        chatController.toUser = letterModel.toUser;
    }
    [self.navigationController pushViewController:chatController animated:YES];
}

@end
