//
//  BackCrashViewController.m
//  jiabasha
//
//  Created by LY123 on 2017/3/16.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BackCrashViewController.h"
#import "JGFriend.h"
#import "JGFriendGroup.h"
#import "JGFriendCell.h"
#import "JGHeaderView.h"
#import "BackCrashRequest.h"
#import "MyOrderViewController.h"
@interface BackCrashViewController ()<UITableViewDelegate,UITableViewDataSource,JGHeaderViewDelegate>
@property(nonatomic,strong)UITableView *CrashtableView;
@property(nonatomic,strong)UIScrollView *fullScroller;
@property (nonatomic, strong) NSArray *groups;
@property(nonatomic,strong)NSString *typeCrash;//返现方式
@end

@implementation BackCrashViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];//KRGBCOLOR(240,240,240);
    //顶部菜单
    UIView *theTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    
    [self.view addSubview:theTopView];
    
    UILabel *theTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];
    theTitleLabel.text = @"返现方式";
    theTitleLabel.font = [UIFont systemFontOfSize:18];
    theTitleLabel.textColor = [UIColor blackColor];
    theTitleLabel.textAlignment = NSTextAlignmentCenter;
    [theTopView addSubview:theTitleLabel];
    
    UIButton *theBackBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 44)];
    theBackBt.backgroundColor = [UIColor clearColor];
    [theBackBt setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [theBackBt addTarget:self action:@selector(comeback) forControlEvents:UIControlEventTouchUpInside];
    [theTopView addSubview:theBackBt];
    
    _fullScroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    _fullScroller.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
   // _fullScroller.backgroundColor=[UIColor redColor];
    _fullScroller.showsVerticalScrollIndicator=NO;
    _fullScroller.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:_fullScroller];
    
    UIButton *bootm=[[UIButton alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40, [UIScreen mainScreen].bounds.size.width, 40)];
    [bootm setTitle:@"提交" forState:UIControlStateNormal];
    [bootm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bootm.backgroundColor=[UIColor colorWithRed:96/255.0 green:21/255.0 blue:131/255.0 alpha:1.0];
    [self.view addSubview:bootm];
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 40)];
    headView.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    UILabel *headLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, headView.frame.size.width-40, 40)];
    headLabel.font=[UIFont systemFontOfSize:13];
    headLabel.textAlignment=NSTextAlignmentLeft;
    headLabel.numberOfLines=0;
    headLabel.text=@"请填写返现方式，如果该订单符合返现规则，中国婚博会将及时通知您返现进度。";
    headLabel.textColor=[UIColor blackColor];
    [headView addSubview:headLabel];
    [_fullScroller addSubview:headView];
    //tableView
    _CrashtableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, _fullScroller.frame.size.height)];
    _CrashtableView.delegate=self;
    _CrashtableView.dataSource=self;
    //每一行cell 的高度
    self.CrashtableView.rowHeight = 40;
    //每一组头部控件的高度
    self.CrashtableView.sectionHeaderHeight = 40;
    self.CrashtableView.tableFooterView=[[UIView alloc]init];

   // _CrashtableView.backgroundColor=[UIColor greenColor];
    [_fullScroller addSubview:_CrashtableView];
}

- (NSArray *)groups {
    
    if (!_groups) {
        NSDictionary *dic1=@{@"name":@"银行卡卡号:"};
        NSDictionary *dic2=@{@"name":@"持卡人姓名:"};
        NSDictionary *dic3=@{@"name":@"身份证号码:"};
        
        NSDictionary *dic4=@{@"name":@"您的姓名:"};
        NSDictionary *dic5=@{@"name":@"联系电话:"};
        NSDictionary *dic6=@{@"name":@"身份证号码:"};
        NSDictionary *dic7=@{@"name":@"领取地址:"};
        
        NSArray *listarray=[NSArray arrayWithObjects:dic1,dic2,dic3,nil];
        NSArray *listArray2=[NSArray arrayWithObjects:dic4,dic5,dic6,dic7, nil];
        NSMutableDictionary *dicHead=[NSMutableDictionary dictionaryWithObjectsAndKeys:listarray,@"friends",@"推荐：使用银行卡返现",@"name" ,nil];
        NSMutableDictionary *dicFoot=[NSMutableDictionary dictionaryWithObjectsAndKeys:listArray2,@"friends",@"到中国婚博会家装展领取",@"name", nil];
        NSMutableArray *dictArr = [NSMutableArray array];
        [dictArr addObject:dicHead];
        [dictArr addObject:dicFoot];
        NSLog(@"******==%@",dictArr);
        NSMutableArray *groupArr = [NSMutableArray array];
        for (NSDictionary *dict in dictArr) {
            JGFriendGroup *group = [JGFriendGroup groupWithDict:dict];
            [groupArr addObject:group];
        }
        _groups = groupArr;
    }
    return _groups;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - 数据源方法 -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    JGFriendGroup *group = self.groups[section];
    return (group.isOpend ? group.friends.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //1. 创建cell
    JGFriendCell *cell = [JGFriendCell cellWithTableView:tableView];
    if(indexPath.section==0){
        cell.MtextField.tag=indexPath.row+100;
        
        cell.MtextField.text=@"";
        
    }else if (indexPath.section==1){
        cell.MtextField.tag=indexPath.row+1000;
        
        cell.MtextField.text=@"";
    }

    //2. 设置cell的数据
    JGFriendGroup *group = self.groups[indexPath.section];
    cell.friendData = group.friends[indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //1. 创建头部控件
    JGHeaderView *header = [JGHeaderView headerViewWithTableView:tableView];
    header.delegate = self;
    
    //2. 给header设置数据（传模型）
    header.group = self.groups[section];
    if(header.group.isOpend==YES){
        header.nameView.selected=YES;
    }else{
        header.nameView.selected=NO;
    }

    
    //    NSLog(@"%p  - %ld",header, (long)section);
    
    return header;
}

#pragma mark - JGHeaderView代理方法
- (void)headerViewDidClickedNameView:(JGHeaderView *)headerView {
    [self.CrashtableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    view.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, [UIScreen mainScreen].bounds.size.width-40, 20)];
    textLabel.font=[UIFont systemFontOfSize:12];
    textLabel.textColor=[UIColor colorWithRed:96/255.0 green:25/255.0 blue:134/255.0 alpha:1.0];
    [view addSubview:textLabel];
    
        textLabel.text=@"注：以上信息请认真核对，一旦提交，那就无法修改";
       
   
    return view;
}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
-(void)comeback{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)Commit{
    //DATA_ENV.userInfo.user.phone
    NSDictionary *param;
    
    if ([_typeCrash isEqualToString:@"3"]) {
        UITextField *text1=(UITextField *)[self.view viewWithTag:100];
        UITextField *text2=(UITextField *)[self.view viewWithTag:101];
        UITextField *text3=(UITextField *)[self.view viewWithTag:102];
        
        param = [NSDictionary dictionaryWithObjectsAndKeys:@"3",@"return_type",text1.text,@"bank_card_id",text2.text,@"bank_card_name",text3.text,@"id_card", nil];
        NSLog(@"===%@",param);
    } else if([_typeCrash isEqualToString:@"2"]){
        UITextField *text1=(UITextField *)[self.view viewWithTag:1000];
        UITextField *text2=(UITextField *)[self.view viewWithTag:1001];
        UITextField *text3=(UITextField *)[self.view viewWithTag:1002];
        
        param = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"return_type",text1.text,@"name",text2.text,@"phone",text3.text,@"id_carde", nil];
        NSLog(@"===%@",param);
        
    }
    
    [BackCrashRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[BackCrashRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            [self.view makeToast:@"提交成功" duration:1 position:CSToastPositionCenter];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                
                if ([controller isKindOfClass:[MyOrderViewController class]]) {
                    
                    [self.navigationController popToViewController:controller animated:YES];
                    
                }
                
            }
        } else {
            NSLog(@"****==%@",request.resultDic);
            [self.view makeToast:@"提交失败" duration:1 position:CSToastPositionCenter];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
        [self.view makeToast:@"提交失败" duration:1 position:CSToastPositionCenter];
    }];
    
}

@end
