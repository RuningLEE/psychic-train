//
//  ChatListViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/11.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ChatListViewController.h"
#import "ReceiveMessageTableViewCell.h"
#import "SendMessageTableViewCell.h"
#import "GetSessionRecordRequest.h"
#import "SessionLetter.h"
#import "SendLetterRequest.h"

@interface ChatListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrChatList;
@property (strong, nonatomic) NSDictionary *dicUser;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewInputBottomConstant;
@property (weak, nonatomic) IBOutlet UITextField *textfieldInput;
@property (weak, nonatomic) IBOutlet UIView *textfieldBgView;
@property (assign, nonatomic) int page;
@property (assign, nonatomic, getter=isRefreshing) BOOL refreshing;
@end

@implementation ChatListViewController

//进入画面之前使tableview滚动到最后一行
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view layoutSubviews];
    _labelTitle.text = _toUser.uname;
}

//滚动到底部
- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height-80)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始组件
- (void)setup{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGB(246, 246, 246);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"ReceiveMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellReceive"];
    [_tableView registerNib:[UINib nibWithNibName:@"SendMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellSend"];
    
    _textfieldBgView.layer.cornerRadius = 15;
    _textfieldBgView.layer.masksToBounds = YES;
    //xcode8中防止输入汉字时下沉
    _textfieldInput.borderStyle = UITextBorderStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPosition:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HidechangeContentViewPosition:) name:UIKeyboardWillHideNotification object:nil];
    [self addRefreshing];
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - lazy init
- (NSDictionary *)dicUser
{
    if (_dicUser == nil) {
        _dicUser = [NSDictionary dictionary];
    }
    return _dicUser;
}

- (NSMutableArray *)arrChatList
{
    if (_arrChatList == nil) {
        _arrChatList = [NSMutableArray array];
    }
    return _arrChatList;
}

#pragma mark - 添加刷新组件
- (void)addRefreshing{
    //添加下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _refreshing = YES;
        [self getChatRecordRequest];
    }];
    _tableView.mj_header.automaticallyChangeAlpha = YES;
}

//监听键盘高度发生改变
- (void) changeContentViewPosition:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat height = value.CGRectValue.size.height;
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        _viewInputBottomConstant.constant = height;
    } completion:^(BOOL finished) {
        [self scrollViewToBottom:YES];
    }];
}

- (void) HidechangeContentViewPosition:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:duration.doubleValue+0.1f animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        self.viewInputBottomConstant.constant = 0;
    }];
}

#pragma mark - Request
- (void)getChatRecordRequest{
/*
 "uid": "4561250","to_uid": "11500911","page":"0","size":"20","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
 */
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_toId,@"to_uid",PAGESIZE,@"size",[NSString stringWithFormat:@"%d",_page],@"page", nil];
    [GetSessionRecordRequest requestWithParameters:param withCacheType:0 withIndicatorView:nil withCancelSubject:[GetSessionRecordRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([RESPONSE_OK isEqualToString:request.errCode]) {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            NSArray *resultArray = [request.resultDic objectForKey:@"sessionRecordModel"];
            if ([resultArray count] < 20) {
                _tableView.mj_footer.hidden = YES;
            } else {
                _tableView.mj_footer.hidden = NO;
                _page++;
            }
            [weakSelf.arrChatList addObjectsFromArray:[NSMutableArray arrayWithArray:[request.resultDic objectForKey:@"sessionRecordModel"]]];
            [weakSelf.tableView reloadData];
        } else {
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
        //刚开始进入页面读取数据让tableview自动滚动最底部
        if (_page-1 == 0) {
            [self scrollViewToBottom:NO];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrChatList.count;
} 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SessionLetter *sessionModel = (SessionLetter *)[self.arrChatList objectAtIndex:indexPath.row];
    if ([sessionModel.toUid isEqualToString:_toId]) {
        SendMessageTableViewCell *cellSend = [tableView dequeueReusableCellWithIdentifier:@"cellSend"];
        cellSend.selectionStyle = UITableViewCellSelectionStyleNone;
        cellSend.user = DATA_ENV.userInfo.user;
        cellSend.letterModel = sessionModel;
        return cellSend;
    }else{
        ReceiveMessageTableViewCell *cellreceive = [tableView dequeueReusableCellWithIdentifier:@"cellReceive"];
        cellreceive.selectionStyle = UITableViewCellSelectionStyleNone;
        cellreceive.user = _toUser;
        cellreceive.letterModel = sessionModel;
        return cellreceive;
    }
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SessionLetter *sessionModel = (SessionLetter *)[self.arrChatList objectAtIndex:indexPath.row];
    NSString *content = sessionModel.content;
    CGFloat contentHeight = [CommonUtil sizeWithString:content fontSize:15 sizewidth:(kScreenWidth-90-16-40-15) sizeheight:0].height;
    if (contentHeight <= 28) {
        return 72;
    } else {
        return contentHeight+30+15;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.textfieldInput endEditing:YES];
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendMessage:(id)sender {
    [_textfieldInput resignFirstResponder];
    //发送消息
    /*
     "from_uid": "4561250","to_uid": "11500911","msg": "发送的内容","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
     */
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_toId,@"to_uid",_textfieldInput.text,@"msg", nil];
    [SendLetterRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[SendLetterRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            [self.view makeToast:@"发送成功"];
        } else {
            [self.view makeToast:@"发送失败"];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

@end
