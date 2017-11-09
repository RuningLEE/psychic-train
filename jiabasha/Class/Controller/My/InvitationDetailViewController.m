//
//  InvitationDetailViewController.m
//  jiabasha
//
//  Created by zhangzt on 2017/2/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "InvitationDetailViewController.h"
#import "MineInvitationTableViewCell.h"
#import "CommonWebViewController.h"
#import "WebViewController.h"

@interface InvitationDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelVip;
@property (weak, nonatomic) IBOutlet UILabel *labelMobile;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrDetail;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UIView *viewFooter;
@property (weak, nonatomic) IBOutlet UILabel *labelphone;
@property (strong, nonatomic) IBOutlet UIView *viewNotify;
@end

@implementation InvitationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpHeaderView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpHeaderView{
    _labelName.text = [NSString stringWithFormat:@"新人姓名：%@",_qrModel.uname];
    //初始化UI
    if ([_qrModel.userLevel isEqualToString:@"new"]) {
        _labelVip.text = @"会员身份：新会员";
    } else if ([_qrModel.userLevel isEqualToString:@"old"]) {
        _labelVip.text = @"会员身份：老会员";
    } else if ([_qrModel.userLevel isEqualToString:@"vip"]) {
        _labelVip.text = @"会员身份：Vip会员";
    } else {
        _labelVip.text = @"会员身份：金卡会员";
    }
    _labelMobile.text = [NSString stringWithFormat:@"绑定手机：%@",_qrModel.phone];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"MineInvitationTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellInvitation"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _viewHeader.frame = CGRectMake(0, 0, kScreenWidth, 150);
    _tableView.tableHeaderView = _viewHeader;
    _viewFooter.frame = CGRectMake(0, 0, kScreenWidth, 100);
    _tableView.tableFooterView = _viewFooter;
    [_tableView reloadData];
    
    _viewNotify.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:_viewNotify];
    _viewNotify.hidden = YES;
    if ([DATA_ENV.userInfo.user.cityId isEqualToString:@"330100"]) {
        _labelphone.text = @"0571-28198188";
    } else {
        _labelphone.text = @"4000-365-520";
    }
}

#pragma mark - Button Click

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callMethod:(id)sender {
    _viewNotify.hidden = NO;
}

- (IBAction)callAction:(id)sender {
    if (![CommonUtil isEmpty:_labelphone.text]) {
        NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",_labelphone.text]; //而这个方法则打电话前先弹框 是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    }
}

- (IBAction)cancelCall:(id)sender {
    _viewNotify.hidden = YES;
}
#pragma mark - tableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvitaionDetailModel *detailModel = (InvitaionDetailModel *)self.arrDetailModel[indexPath.row];
    if (self.arrDetailModel.count == 4) {
        if (indexPath.row == 2) {
            return [CommonUtil sizeWithString:detailModel.desc fontSize:12 sizewidth:kScreenWidth-40 sizeheight:0].height + 57 + 30;//防止点击部分出现。。。
        }
    }
    return [CommonUtil sizeWithString:detailModel.desc fontSize:12 sizewidth:kScreenWidth-40 sizeheight:0].height + 57;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrDetailModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    InvitaionDetailModel *detailModel = (InvitaionDetailModel *)self.arrDetailModel[indexPath.row];
    MineInvitationTableViewCell *cellRemind = [tableView dequeueReusableCellWithIdentifier:@"cellInvitation"];
    cellRemind.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cellRemind.viewTop.hidden = YES;
        cellRemind.viewBottom.hidden = NO;
    } else if (indexPath.row+1 == self.arrDetailModel.count){
        cellRemind.viewBottom.hidden = YES;
        cellRemind.viewTop.hidden = NO;
    } else {
        cellRemind.viewBottom.hidden = NO;
        cellRemind.viewTop.hidden = NO;
    }
    cellRemind.labelTitle.text = detailModel.name;
    cellRemind.labelDesc.text  = detailModel.desc;
    if (detailModel.status) {
        cellRemind.imageViewMark.image = [UIImage imageNamed:@"选中"];
        cellRemind.labelTitle.textColor = RGB(41, 166, 2);
    } else {
        cellRemind.imageViewMark.image = [UIImage imageNamed:@"未选中"];
        cellRemind.labelTitle.textColor = RGB(153, 153, 153);
    }
    if (indexPath.row == 2) {
        if (detailModel.status) {
            cellRemind.yyLabelDesc.hidden = NO;
            cellRemind.yyLabelDesc.text = [NSString stringWithFormat:@"%@ 查询物流信息",cellRemind.labelDesc.text];
            NSRange range = [cellRemind.yyLabelDesc.text rangeOfString:@"查询物流信息"];
            NSMutableAttributedString* attribute_str = [[NSMutableAttributedString alloc]initWithString:cellRemind.yyLabelDesc.text];
            attribute_str.yy_color = RGB(51, 51, 51);
            [attribute_str yy_setTextHighlightRange:NSMakeRange(range.location, 6) color:[UIColor blueColor] backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                WebViewController *webViewController = [[WebViewController alloc]init];
                webViewController.urlString = detailModel.queryUrl;
                webViewController.urlTitle = @"快递查询";
                [weakSelf.navigationController pushViewController:webViewController animated:YES];
            }];
            cellRemind.yyLabelDesc.attributedText = attribute_str;
            cellRemind.labelDesc.hidden = YES;
        }
    } else {
        cellRemind.yyLabelDesc.hidden = YES;
        cellRemind.labelDesc.hidden = NO;
    }
    return cellRemind;
}


@end
