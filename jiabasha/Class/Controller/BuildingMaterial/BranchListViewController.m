//
//  BranchListViewController.m
//  jiabasha
//
//  Created by 金伟城 on 16/12/29.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "storeBranch.h"
#import "BuildingStoreDetail.h"
#import "BranchTableViewCell.h"
#import "GetStoreBranchRequest.h"
#import "CompanyHomeViewController.h"
#import "BranchListViewController.h"
#import "FreeFunctionViewController.h"

@interface BranchListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viewHead;
@property (weak, nonatomic) IBOutlet UILabel *labelMainCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *labelMainAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelAllNumStore;
@property (weak, nonatomic) IBOutlet UILabel *labelBranchAddress;

@property (strong, nonatomic) NSMutableArray *branchList;

@end

@implementation BranchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _branchList = [NSMutableArray array];
    self.labelBranchAddress.text = DATA_ENV.city.sname ;
    // Do any additional setup after loading the view from its nib.
    self.viewHead.frame = CGRectMake(0, 0, kScreenWidth, 123);
    self.tableView.tableHeaderView = self.viewHead;
    
    self.labelMainCompanyName.text = _buildingStoreDetail.storeName;
    self.labelMainAddress.text = _buildingStoreDetail.address;
    [self getGoodsDetailData];
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
#pragma mark- tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
   
    return _branchList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString * branchTableViewCell = @"BranchTableViewCell";
    BranchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:branchTableViewCell];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"BranchTableViewCell" bundle:nil] forCellReuseIdentifier:branchTableViewCell];
        cell = [tableView dequeueReusableCellWithIdentifier:branchTableViewCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    storeBranch *storeBranch = _branchList[indexPath.row];
    cell.labelCompanyName.text = storeBranch.branchName;
    cell.labelAddress.text = storeBranch.address;
    return cell;
    
}

#pragma mark- tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    return 76;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    storeBranch *storeBranch = _branchList[indexPath.row];
    CompanyHomeViewController *view = [[CompanyHomeViewController alloc] initWithNibName:@"CompanyHomeViewController" bundle:nil];
    view.storeId = storeBranch.storeId;
    [self.navigationController pushViewController:view animated:YES];
    
}

// 返回
- (IBAction)btnClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 免费预约
- (IBAction)btnClickFreeAppiont:(id)sender {
    FreeFunctionViewController *view = [[FreeFunctionViewController alloc] initWithNibName:@"FreeFunctionViewController" bundle:nil];
    view.freeType = @"3";
    view.storeId = _buildingStoreDetail.storeId;
    [self.navigationController pushViewController:view animated:YES];
}


#pragma mark - private
//取分店数据
- (void)getGoodsDetailData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_buildingStoreDetail.storeId forKey:@"store_id"];
    __weak typeof(self) weakSelf = self;
    [GetStoreBranchRequest requestWithParameters:parameters
                                            withCacheType:DataCacheManagerCacheTypeMemory
                                        withIndicatorView:self.view
                                        withCancelSubject:[GetStoreBranchRequest getDefaultRequstName]
                                           onRequestStart:nil
                                        onRequestFinished:^(CIWBaseDataRequest *request) {
                                            
                                            if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                                
                                                weakSelf.branchList = [request.resultDic objectForKey:@"storeBranch"];
                                                [self.tableView reloadData];
                                                
                                                NSString *num = [NSString stringWithFormat:@"%ld家",_branchList.count];
                                                NSString *numStore = [NSString stringWithFormat:@"全部%@分店",num];
                                                NSMutableAttributedString *numStoreString = [[NSMutableAttributedString alloc] initWithString:numStore];
                                                [numStoreString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(0,2)];
                                                [numStoreString addAttribute:NSForegroundColorAttributeName value:RGB(255, 59, 48) range:NSMakeRange(2,num.length)];
                                                [numStoreString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(2+num.length,2)];
                                                self.labelAllNumStore.attributedText = numStoreString;
                                             
                                                
                                            }
                                            
                                        }
                                        onRequestCanceled:^(CIWBaseDataRequest *request) {
                                            
                                        }
                                          onRequestFailed:^(CIWBaseDataRequest *request) {
                                              
                                          }];
}


@end
