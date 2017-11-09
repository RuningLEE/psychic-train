//
//  CaseHomeViewController.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/3.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ShareView.h"
#import "ExampleDetail.h"
#import "ShareViewController.h"
#import "CaseHomeTableViewCell.h"
#import "CaseHomeViewController.h"
#import "GetMallExampleDetailRequest.h"
#import "FreeFunctionViewController.h"
#import "CasePictureShowViewController.h"
#import "CompanyHomeViewController.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <MessageUI/MessageUI.h>

@interface CaseHomeViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate, TencentSessionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viewHead;
@property (weak, nonatomic) IBOutlet UIView *viewHeadTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCompany; // 公司图标
@property (weak, nonatomic) IBOutlet UILabel *labelCompanyName;// 公司名字
@property (weak, nonatomic) IBOutlet UILabel *labelStyle; // 多少M2几室
@property (weak, nonatomic) IBOutlet UILabel *labelAddressPrice; // 地方价钱
@property (weak, nonatomic) IBOutlet UILabel *labelIntroduction; // 简介
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewIntroductionHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckIntroduction;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewJianTou;


@property (strong, nonatomic) ShareView *viewShare; // 分享

// 数据源
@property (strong, nonatomic)ExampleDetail *exampleDetail;

@property (assign ,nonatomic) NSInteger selectRow;
@property(nonatomic,strong)NSString *companyId;
@property(nonatomic,strong)UIView *popView;
@property(nonatomic,strong)UIView *thirdShareView;
@end

@implementation CaseHomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [self getExampleDetailData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getExampleDetailData];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer * PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView)];
    _imageViewCompany.userInteractionEnabled=YES;
    [_imageViewCompany addGestureRecognizer:PrivateLetterTap];
    
    _selectRow = 999999;
    self.labelTitle.text = @"案例";
    self.viewHead.frame = CGRectMake(0, 0, kScreenWidth, 111);
    self.tableView.tableHeaderView = self.viewHead;
    [self getExampleDetailData];
}
#pragma mark 跳转
-(void)tapAvatarView{
    NSLog(@"ud==%@",_companyId);
    CompanyHomeViewController *view = [[CompanyHomeViewController alloc] initWithNibName:@"CompanyHomeViewController" bundle:nil];
    view.storeId = _companyId;
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

- (void)setUi{
    self.labelStyle.text = _exampleDetail.albumText;
    self.labelAddressPrice.text = _exampleDetail.albumPriceText;
    
    NSDictionary *store = _exampleDetail.store;
    [self.imageViewCompany sd_setImageWithURL:[NSURL URLWithString:[store[@"logo"] description]] placeholderImage:[UIImage imageNamed:SMALLPALCEHOLDERIMG]];
    self.labelCompanyName.text = [store[@"store_name"] description];
//    self.labelTitle.text = [store[@"store_name"] description];
}

#pragma mark- tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    
    NSArray *child = _exampleDetail.child;
    return child.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    static NSString * caseHomeTableViewCell = @"CaseHomeTableViewCell";
    CaseHomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:caseHomeTableViewCell];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"CaseHomeTableViewCell" bundle:nil] forCellReuseIdentifier:caseHomeTableViewCell];
        cell = [tableView dequeueReusableCellWithIdentifier:caseHomeTableViewCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.viewProfile.hidden = YES;
    [cell.btnWatchProfiles setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    cell.imageViewJianTou.image = [UIImage imageNamed:@"展开箭头"];
    if (self.selectRow == indexPath.row) {
        cell.viewProfile.hidden = NO;
        [cell.btnWatchProfiles setTitleColor:RGB(255, 59, 48) forState:UIControlStateNormal];
         cell.imageViewJianTou.image = [UIImage imageNamed:@"收回箭头"];
        
    }
    cell.btnWatchProfiles.tag = indexPath.row;
    [cell.btnWatchProfiles addTarget:self action:@selector(btnWatchProfiles:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *child = _exampleDetail.child;
    NSDictionary *dic = child[indexPath.row];
    [cell loadCell:dic];
    return cell;
    
}

#pragma mark- tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSArray *child = _exampleDetail.child;
    NSDictionary *dic = child[indexPath.row];
    NSString *desc = [dic[@"desc"] description];
    float commentHeight = 60;
    if (desc != nil) {
        CGSize contentSize = [desc  boundingRectWithSize:CGSizeMake(kScreenWidth - 32, MAXFLOAT)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                     attributes:@{NSFontAttributeName:
                                                                                      [UIFont systemFontOfSize:12]}
                                                                        context:nil].size;
        commentHeight = contentSize.height + 16;
    }

    if (self.selectRow == indexPath.row) {
         return 310 + commentHeight;
    }
    return 310;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _exampleDetail.child[indexPath.row];
    CasePictureShowViewController *view = [[CasePictureShowViewController alloc] initWithNibName:@"CasePictureShowViewController" bundle:nil];
    view.exampleDetail = _exampleDetail;
    view.childId = [dic[@"child_id"] description];
    [self.navigationController pushViewController:view animated:YES];
}

// 返回
- (IBAction)btnClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 免费预约
- (IBAction)btnClickFreeAppiont:(id)sender {
    NSDictionary *store = _exampleDetail.store;
    FreeFunctionViewController *view = [[FreeFunctionViewController alloc] initWithNibName:@"FreeFunctionViewController" bundle:nil];
    view.freeType = @"3";
    view.storeId = [store[@"store_id"] description];
    view.companyName=[store[@"store_name"] description];
    NSLog(@"*****==%@",store);
    [self.navigationController pushViewController:view animated:YES];
}

// 查看总案例简介
- (IBAction)btnWatchHeadProfiles:(UIButton *)sender {
    if (sender.selected) {
        _viewHead.height = 111;
        sender.selected = NO;
        _viewHeadTitle.hidden = YES;
        [_btnCheckIntroduction setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        _imageViewJianTou.image = [UIImage imageNamed:@"展开箭头"];
    }else{
        NSString * setting = _exampleDetail.albumDesc;
        self.labelIntroduction.text = setting;
        float commentHeight = 60;
        if (setting != nil) {
            CGSize contentSize = [setting boundingRectWithSize:CGSizeMake(kScreenWidth - 32, MAXFLOAT)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                   attributes:@{NSFontAttributeName:
                                                                                    [UIFont systemFontOfSize:12]}
                                                                      context:nil].size;
            commentHeight = contentSize.height + 16;
        }

        _viewIntroductionHeight.constant =  commentHeight;
        _viewHead.height = 111 + commentHeight;
         sender.selected = YES;
        _viewHeadTitle.hidden = NO;
        [_btnCheckIntroduction setTitleColor:RGB(255, 59, 48) forState:UIControlStateNormal];
        _imageViewJianTou.image = [UIImage imageNamed:@"收回箭头"];
        
    }
    [self.tableView setTableHeaderView:_viewHead];
}

// 查看案例简介
- (void)btnWatchProfiles:(UIButton *)sender {
    if (self.selectRow == sender.tag) {
        self.selectRow = 999999;
    }else{
        self.selectRow = sender.tag;
    }
    [self.tableView reloadData];
}

// 分享
- (IBAction)btnClickShare:(id)sender {
//    if (_exampleDetail == nil) {
//        return;
//    }
//    NSString *url = [NSString stringWithFormat:@"http://h5.jiabasha.com/album/%@",_exampleDetail.albumId];
//    NSString *title = _exampleDetail.albumName;
//    NSDictionary *shareDic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title", _exampleDetail.showImgUrl,@"logo",url,@"link",nil];
//
//    ShareViewController *viewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
//    viewController.shareContent = shareDic;
//
//    UIViewController* controller = self.view.window.rootViewController;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
//        viewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//    }else{
//        controller.modalPresentationStyle = UIModalPresentationCurrentContext;
//    }
//    
//    [controller presentViewController:viewController animated:YES completion:^{
//        viewController.view.superview.backgroundColor = [UIColor clearColor];
//    }];
    //添加蒙版
    _popView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _popView.backgroundColor=[UIColor blackColor];
    _popView.alpha=0.8;
    _popView.tag=86;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteView)];
    [ _popView addGestureRecognizer:tap1];
    [[UIApplication sharedApplication].keyWindow addSubview: _popView];
    
    //第三方分享view
    _thirdShareView=[[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 210)];
    
    [UIView animateWithDuration:0.5 animations:^{
        _thirdShareView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-210, [UIScreen mainScreen].bounds.size.width, 210);
        [[UIApplication sharedApplication].keyWindow addSubview: _thirdShareView];
        
    }completion:^(BOOL finish){
        [UIView animateWithDuration:0.5 animations:^{
            
        }completion:nil];
    }];
    _thirdShareView.backgroundColor=[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    
    UIView *firstView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _thirdShareView.frame.size.width, 150)];
    firstView.backgroundColor=[UIColor whiteColor];
    UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(25, 25, (_thirdShareView.frame.size.width-25*2-60*2)/3, (_thirdShareView.frame.size.width-25*2-60*2)/3)];
    imageView1.userInteractionEnabled=YES;
    UITapGestureRecognizer *WXtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weixinShare)];
    [ imageView1 addGestureRecognizer:WXtap];
    imageView1.image=[UIImage imageNamed:@"微信"];
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(imageView1.frame.origin.x, imageView1.frame.origin.y+imageView1.frame.size.height+5, imageView1.frame.size.width, 25)];
    label1.text=@"微信";
    label1.font=[UIFont systemFontOfSize:13];
    label1.textAlignment=NSTextAlignmentCenter;
    
    UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(25+60+imageView1.frame.size.width, 25, (_thirdShareView.frame.size.width-25*2-60*2)/3, (_thirdShareView.frame.size.width-25*2-60*2)/3)];
    imageView2.userInteractionEnabled=YES;
    UITapGestureRecognizer *PYtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wxPyquanshare)];
    [ imageView2 addGestureRecognizer:PYtap];
    imageView2.image=[UIImage imageNamed:@"朋友圈"];
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(imageView2.frame.origin.x, imageView2.frame.origin.y+imageView2.frame.size.height+5, imageView1.frame.size.width, 25)];
    label2.text=@"朋友圈";
    label2.font=[UIFont systemFontOfSize:13];
    label2.textAlignment=NSTextAlignmentCenter;
    
    UIImageView *imageView3=[[UIImageView alloc]initWithFrame:CGRectMake(25+60*2+imageView2.frame.size.width*2, 25, (_thirdShareView.frame.size.width-25*2-60*2)/3, (_thirdShareView.frame.size.width-25*2-60*2)/3)];
    imageView3.userInteractionEnabled=YES;
    UITapGestureRecognizer *FZtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pasteLink)];
    [ imageView3 addGestureRecognizer:FZtap];
    imageView3.image=[UIImage imageNamed:@"复制链接"];
    
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(imageView3.frame.origin.x, imageView3.frame.origin.y+imageView3.frame.size.height+5, imageView3.frame.size.width, 25)];
    label3.text=@"复制链接";
    label3.font=[UIFont systemFontOfSize:13];
    label3.textAlignment=NSTextAlignmentCenter;
    [firstView addSubview:imageView1];
    [firstView addSubview:label1];
    [firstView addSubview:imageView2];
    [firstView addSubview:label2];
    [firstView addSubview:imageView3];
    [firstView addSubview:label3];
    [_thirdShareView addSubview:firstView];
    
    UIButton *SecdBut=[[UIButton alloc]initWithFrame:CGRectMake(0, firstView.frame.origin.y+firstView.frame.size.height+10, [UIScreen mainScreen].bounds.size.width, 50)];
    SecdBut.backgroundColor=[UIColor whiteColor];
    [SecdBut setTitle:@"取消" forState: UIControlStateNormal];
    [SecdBut setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
    SecdBut.titleLabel.font=[UIFont systemFontOfSize:15];
    [SecdBut addTarget:self action:@selector(deleteView) forControlEvents:UIControlEventTouchUpInside];
    [_thirdShareView addSubview:SecdBut];
    
    
}
-(void)deleteView{
    [_popView removeFromSuperview];
    [_thirdShareView removeFromSuperview];
}
#pragma mark - 复制
- (void)pasteLink {
    if (_exampleDetail == nil) {
                return;
            }
            NSString *url = [NSString stringWithFormat:@"http://h5.jiabasha.com/album/%@",_exampleDetail.albumId];
            NSString *title = _exampleDetail.albumName;
            NSDictionary *shareDic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title", _exampleDetail.showImgUrl,@"logo",url,@"link",nil];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = shareDic[@"link"];
    
    [MessageView displayMessage:@"已经复制到剪贴板"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 微信朋友圈
-(void)wxPyquanshare{
    if (![WXApi isWXAppInstalled]) {
        [MessageView displayMessage:@"没有安装微信"];
        return;
    }
//    if(_arrStoreData.count == 0){
//        return;
//    }
    if (_exampleDetail == nil) {
                return;
            }
            NSString *url = [NSString stringWithFormat:@"http://h5.jiabasha.com/album/%@",_exampleDetail.albumId];
            NSString *title = _exampleDetail.albumName;
            NSDictionary *shareDic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title", _exampleDetail.showImgUrl,@"logo",url,@"link",nil];
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareDic[@"title"];
    message.description = shareDic[@"content"];
    UIImage *image;
    if([CommonUtil isEmpty:shareDic[@"logo"]]){
        image = [UIImage imageNamed:@"app_Icon"];
    }else{
        NSURL *url = [NSURL URLWithString:shareDic[@"logo"]];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }
    
    [message setThumbImage:[self imageWithImageSimple:image scaledToSize:CGSizeMake(99, 99) ]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareDic[@"link"];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = 1;
    [WXApi sendReq:req];
    
}


#pragma mark - 微信好友
- (void) weixinShare {
    if (![WXApi isWXAppInstalled]) {
        [MessageView displayMessage:@"没有安装微信"];
        return;
    }
//    if(_arrStoreData.count == 0){
//        return;
//    }
    if (_exampleDetail == nil) {
                return;
            }
            NSString *url = [NSString stringWithFormat:@"http://h5.jiabasha.com/album/%@",_exampleDetail.albumId];
            NSString *title = _exampleDetail.albumName;
            NSDictionary *shareDic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title", _exampleDetail.showImgUrl,@"logo",url,@"link",nil];    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareDic[@"title"];
    message.description = shareDic[@"content"];
    UIImage *image;
    if([CommonUtil isEmpty:shareDic[@"logo"]]){
        image = [UIImage imageNamed:@"app_Icon"];
    }else{
        NSURL *url = [NSURL URLWithString:shareDic[@"logo"]];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }
    
    [message setThumbImage:[self imageWithImageSimple:image scaledToSize:CGSizeMake(99, 99) ]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareDic[@"link"];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = 0;
    [WXApi sendReq:req];
    
}
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (UIImage *)saveImage:(UIImage *)image
{
    //png格式压缩后存入当前图片
    //    UIImage *compressImg = [self imageCompressForWidth:image];
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
    return [UIImage imageWithData:imgData];
    
    
}


// 案例详细
- (void)getExampleDetailData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_albumId forKey:@"album_id"];
   // [parameters setValue:@"38972" forKey:@"album_id"];

    __weak typeof(self) weakSelf = self;
    [GetMallExampleDetailRequest requestWithParameters:parameters
                                     withCacheType:DataCacheManagerCacheTypeMemory
                                 withIndicatorView:self.view
                                 withCancelSubject:[GetMallExampleDetailRequest getDefaultRequstName]
                                    onRequestStart:nil
                                 onRequestFinished:^(CIWBaseDataRequest *request) {
                                     
                                     if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                                         
                                         NSLog(@"****==%@",request.resultDic);
                                         _companyId=request.resultDic[@"data"][@"store_id"];
                                         NSArray *arr = [request.resultDic objectForKey:@"productDetail"];
                                         if (arr.count>0) {
                                             weakSelf.exampleDetail = arr[0];
                                             [self setUi];
                                             [self.tableView reloadData];
                                         }
                                         
                                     }
                                     
                                 }
                                 onRequestCanceled:^(CIWBaseDataRequest *request) {
                                     
                                 }
                                   onRequestFailed:^(CIWBaseDataRequest *request) {
                                       
                                   }];
}


@end
