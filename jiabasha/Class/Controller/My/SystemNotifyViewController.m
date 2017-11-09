//
//  SystemNotifyViewController.m
//  jiabasha
//
//  Created by zhangzt on 2016/12/30.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "SystemNotifyViewController.h"
#import "SystemNoticeTableViewCell.h"
#import "SystemNoticeDetailViewController.h"
#import "GetNoticeListRequest.h"
#import "SystemNotice.h"
#import "DeleteNoticeRequest.h"

@interface SystemNotifyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrSystemNotice;
@property (strong, nonatomic) IBOutlet UIView *viewDelete;
@property (assign, nonatomic) int page;
@property (assign, nonatomic, getter=isRefreshing) BOOL refreshing;
@end

@implementation SystemNotifyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 72;
    _tableView.backgroundColor = RGB(246, 246, 246);
    // Do any additional setup after loading the view from its nib.
    [self addRefreshing];
    [_tableView.mj_header beginRefreshing];
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
        [self getMessageListRequest];
    }];
    
    _tableView.mj_header.automaticallyChangeAlpha = YES;

    //添加上拉刷新
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _refreshing = NO;
        [self getMessageListRequest];
    }];
}

#pragma mark - lazyinit
- (NSMutableArray *)arrSystemNotice
{
    if (_arrSystemNotice == nil) {
        _arrSystemNotice = [[NSMutableArray alloc]init];
    }
    return _arrSystemNotice;
}

#pragma mark - Request
- (void)getMessageListRequest{

    __weak typeof(self) weakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:DATA_ENV.userInfo.user.uid,@"uid",[NSString stringWithFormat:@"%d",_page],@"page",PAGESIZE,@"size",nil];
    [GetNoticeListRequest requestWithParameters:param withCacheType:0 withIndicatorView:nil withCancelSubject:[GetNoticeListRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([RESPONSE_OK isEqualToString:request.errCode]) {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            NSArray *resultArray = [request.resultDic objectForKey:@"arrNoticeModel"];
            if ([resultArray count] < 20) {
                _tableView.mj_footer.hidden = YES;
            } else {
                _tableView.mj_footer.hidden = NO;
                _page++;
            }
            if ([weakSelf isRefreshing] == YES) {//下拉
                [weakSelf.arrSystemNotice removeAllObjects];
                weakSelf.arrSystemNotice = [NSMutableArray arrayWithArray:[request.resultDic objectForKey:@"arrNoticeModel"]];
                [weakSelf.tableView reloadData];
            }else{//上拉
                [weakSelf.arrSystemNotice addObjectsFromArray:[NSMutableArray arrayWithArray:[request.resultDic objectForKey:@"arrNoticeModel"]]];
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
    return self.arrSystemNotice.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemNoticeTableViewCell *systemCell = [[SystemNoticeTableViewCell alloc]initWithTableView:tableView];
    systemCell.systemModel = (SystemNotice *)[self.arrSystemNotice objectAtIndex:indexPath.row];
    return systemCell;
}

#pragma mark - TableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemNotice *systemModel = (SystemNotice *)[self.arrSystemNotice objectAtIndex:indexPath.row];
    SystemNoticeDetailViewController* systemDetail = [[SystemNoticeDetailViewController alloc]init];
    systemDetail.stringHtml = systemModel.content;
    systemDetail.noticeId = systemModel.noticeId;
    systemModel.isread = @"1";
    [self.arrSystemNotice replaceObjectAtIndex:indexPath.row withObject:systemModel];
    [self.navigationController pushViewController:systemDetail animated:YES];
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //准备参数
        //"noticeId": "26718907","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
        SystemNotice *systemModel = (SystemNotice *)[self.arrSystemNotice objectAtIndex:indexPath.row];
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:systemModel.noticeId,@"notice_id", nil];
        [DeleteNoticeRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[DeleteNoticeRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
            
        } onRequestFinished:^(CIWBaseDataRequest *request) {
            if ([request.errCode isEqualToString:RESPONSE_OK]) {
                [self.view makeToast:@"成功删除一条通知" duration:1 position:CSToastPositionCenter];
                [self getMessageListRequest];
            }
        } onRequestCanceled:^(CIWBaseDataRequest *request) {
            
        } onRequestFailed:^(CIWBaseDataRequest *request) {
            
        }];
        //删除选中的通知
        
        //更新列表
        [_tableView reloadData];
    }];
    deleteAction.backgroundColor = RGB(96, 25, 134);
    return @[deleteAction];
}

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

//长按删除
- (void)longPressAction:(UILongPressGestureRecognizer *)longPressTap{
    
}

@end
