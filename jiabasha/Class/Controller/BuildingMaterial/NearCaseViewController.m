//
//  NearCaseViewController.m
//  jiabasha
//
//  Created by LY123 on 2017/3/27.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "NearCaseViewController.h"
#import "CaseTableViewCell.h"
#import "CaseHomeViewController.h"
#import "BuildingExample.h"
@interface NearCaseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UIScrollView *fullScroller;
@end

@implementation NearCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreatUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)CreatUI{
    
    _fullScroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-104)];
    _fullScroller.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:_fullScroller];
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-104)];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [_fullScroller addSubview:_tableview];
    
}
#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return 280;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
        return _exampleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
        BuildingExample *exampleData = _exampleList[indexPath.row];
        CaseHomeViewController *view = [[CaseHomeViewController alloc] initWithNibName:@"CaseHomeViewController" bundle:nil];
        view.albumId = exampleData.albumId;
        [self.navigationController pushViewController:view animated:YES];
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
