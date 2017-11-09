//
//  SettingViewController.m
//  jiabasha
//
//  Created by zhangzt on 2016/12/30.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "LoginViewController.h"
#import "ItroductionTableViewCell.h"
#import "EditHouseInfoViewController.h"
#import "CommonWebViewController.h"
#import "LoginViewController.h"
#import "GeTuiSdk.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) IBOutlet UIView *viewFooter;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogoff;


@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    if (DATA_ENV.isLogin) {
        _buttonLogoff.hidden = NO;
    } else {
        _buttonLogoff.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUp{
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [_TableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"settingcell"];
    [_TableView registerNib:[UINib nibWithNibName:@"ItroductionTableViewCell" bundle:nil] forCellReuseIdentifier:@"introducecell"];
    _viewFooter.frame = CGRectMake(0, 0, kScreenWidth,155);
    _TableView.tableFooterView = _viewFooter;
    _TableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _TableView.backgroundColor = RGB(246, 246, 246);
    _buttonLogoff.layer.cornerRadius = 2;
    _buttonLogoff.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [GeTuiSdk setPushModeForOff:NO];
        [CommonUtil saveObjectToUD:@"YES" key:@"getuiKey"];
    }else {
        [GeTuiSdk setPushModeForOff:YES];
        [CommonUtil saveObjectToUD:@"NO" key:@"getuiKey"];
    }
}

#pragma mark TableView--Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0|| indexPath.row == 5) {
        return 10;
    } else if (indexPath.row == 3){
        return 48;
    } else {
        return 50;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"settingcell"];
     if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"settingcell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.hidden = YES;
    } else if (indexPath.row == 1) {
        cell.labelTitle.text = @"清除缓存";
        cell.switchRight.hidden = YES;
        cell.imageviewArrow.hidden = NO;
    } else if (indexPath.row == 2){
        cell.labelTitle.text = @"推送开关";
        cell.switchRight.hidden = NO;
        cell.imageviewArrow.hidden = YES;
        [cell.switchRight addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        if ([[[CommonUtil getObjectFromUD:@"getuiKey"] description] isEqualToString:@"YES"]) {
            cell.switchRight.on = YES;
        } else {
            cell.switchRight.on = NO;
        }

    } else if (indexPath.row == 3){
        ItroductionTableViewCell* introducecell = [tableView dequeueReusableCellWithIdentifier:@"introducecell"];
        return introducecell;
    } else if (indexPath.row == 4) {
        cell.labelTitle.text = @"完善房产信息";
        cell.switchRight.hidden = YES;
        cell.imageviewArrow.hidden = NO;
    } else if (indexPath.row == 5){
        cell.hidden = YES;
    } else if (indexPath.row == 6){
        cell.labelTitle.text = @"关于中国婚博会——家芭莎";
        cell.switchRight.hidden = YES;
        cell.imageviewArrow.hidden = NO;
    }
    return cell;
}

#pragma mark TabelView--Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [self.view makeToast:@"清除成功" duration:1 position:CSToastPositionCenter];
        return;
    } else if (indexPath.row == 4){
        if ([CommonUtil isEmpty:DATA_ENV.userInfo.user.uid]) {
            LoginViewController *login = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
        } else {
        EditHouseInfoViewController *editController = [[EditHouseInfoViewController alloc]init];
        [self.navigationController pushViewController:editController animated:YES];
        }
            } else if (indexPath.row == 6){
        CommonWebViewController *commonWebViewController = [[CommonWebViewController alloc]init];
        commonWebViewController.sourceType = 3;
        [self.navigationController pushViewController:commonWebViewController animated:YES];
    }
}

#pragma mark ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logOff:(id)sender {
    //清空缓存
    //[DATA_ENV clearNetworkData];
    DATA_ENV.userInfo = nil;
    LoginViewController* login = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}

@end
