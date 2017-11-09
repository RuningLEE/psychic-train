//
//  SubControllerOfHelpCenterViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/4.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "SubControllerOfHelpCenterViewController.h"
#import "HelpCenterTableViewCell.h"
#import "QuestionDetailViewController.h"
#import "GetHelpListRequest.h"
#import "HelpCenterQuestionModel.h"

@interface SubControllerOfHelpCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) NSMutableArray *arrQuestion;
@property (strong, nonatomic) IBOutlet UIView *viewNotify;
@property (weak, nonatomic) IBOutlet UILabel *labelMobile;
@property (weak, nonatomic) IBOutlet UIView *viewCallBg;
@end

@implementation SubControllerOfHelpCenterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _viewNotify.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:_viewNotify];
    _viewNotify.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGB(246, 246, 246);
    [_tableView registerNib:[UINib nibWithNibName:@"HelpCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"helpCell"];
    _labelTitle.text = _Title;
    [self getQuestionListRequest];
    _viewCallBg.layer.cornerRadius = 5;
    _viewCallBg.layer.masksToBounds = YES;
    if ([DATA_ENV.city.cityId isEqualToString:@"330100"]) {
        _labelMobile.text = @"0571-28198188";
    } else {
        _labelMobile.text = @"4000-365-520";
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
- (void)getQuestionListRequest{
//city_id": "110900","category_id": "4", "app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
    __weak typeof(self)WeakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_categoryId,@"category_id", nil];
    [GetHelpListRequest requestWithParameters:param withIsCacheData:NO withIndicatorView:self.view withCancelSubject:[GetHelpListRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
//        KKLog(@"%@",request.resultDic);
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            self.arrQuestion = [request.resultDic objectForKey:@"arrQuesModel"];
            [WeakSelf.tableView reloadData];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

#pragma mark - lazyinit
- (NSMutableArray *)arrQuestion
{
    if (_arrQuestion == nil) {
        _arrQuestion = [NSMutableArray array];
    }
    return _arrQuestion;
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callCustomerAction:(id)sender {
    _viewNotify.hidden = NO;
}

- (IBAction)callMethod:(id)sender {
    if (![CommonUtil isEmpty:_labelMobile.text]) {
        NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",_labelMobile.text]; //而这个方法则打电话前先弹框 是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    }
}

- (IBAction)cancelCall:(id)sender {
    _viewNotify.hidden = YES;
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrQuestion.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelpCenterQuestionModel *questionModel = (HelpCenterQuestionModel *)[self.arrQuestion objectAtIndex:indexPath.row];
    HelpCenterTableViewCell* helpCell = [tableView dequeueReusableCellWithIdentifier:@"helpCell"];
    helpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    helpCell.labelQuestion.text = questionModel.contentTitle;
    return helpCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelpCenterQuestionModel *questionModel = (HelpCenterQuestionModel *)[self.arrQuestion objectAtIndex:indexPath.row];
    QuestionDetailViewController *quesController = [[QuestionDetailViewController alloc]init];
    quesController.contentId = questionModel.contentId;
    [self.navigationController pushViewController:quesController animated:YES];
}

@end
