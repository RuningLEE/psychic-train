//
//  AuthenticationDetialViewController.m
//  jiabasha
//
//  Created by 金伟城 on 16/12/29.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "StoreRzModel.h"
#import "MSSBrowseDefine.h"
#import "GetMallStoreRzRequest.h"
#import "FreeFunctionViewController.h"
#import "AuthenticationDetialViewController.h"

@interface AuthenticationDetialViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewMain;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *labelCompanyIntroduce; // 公司介绍
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelCompanyHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewOne;
@property (weak, nonatomic) IBOutlet UILabel *labelNameOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelNameTwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewGuaranteeHeight;
@property (weak, nonatomic) IBOutlet UIView *viewGuarantee;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewImage;

@property (strong, nonatomic) StoreRzModel *storeRzModel;

@end

@implementation AuthenticationDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.viewMain.constant = 600;
    [self getStoreDetailData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImages{
    NSArray *honor = _storeRzModel.honor;
    for (int a = 0; a < honor.count; a++) {
        NSDictionary *dic = honor[a];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-20)/2 *a, 0, (kScreenWidth-20)/2 , 150)];
        
        UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10,  (kScreenWidth-20)/2 -15, 100)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[dic[@"pic_url"] description]] placeholderImage:[UIImage imageNamed:RECTPLACEHOLDERIMG]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = a;
        UITapGestureRecognizer* enlarge_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickImageViewToEnlargeWithImageView:)];
        [imageView addGestureRecognizer:enlarge_tap];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 118,  (kScreenWidth-20)/2 -15, 20)];
        label.text = [dic[@"desc"] description];
        label.font = [UIFont systemFontOfSize:13.0];
        label.textColor = RGB(102, 102, 102);
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:imageView];
        [view addSubview:label];
        [self.scrollViewImage addSubview:view];
   
    }
    [self.scrollViewImage setContentSize:CGSizeMake((kScreenWidth-20)/2 *honor.count, 150)];
}

- (void)setMainUi{
    self.labelCompanyIntroduce.text = _storeRzModel.describe;
    
    float CompanyHeight = 162;
    if (_storeRzModel.describe != nil) {
        CGSize contentSize = [_storeRzModel.describe boundingRectWithSize:CGSizeMake(kScreenWidth - 40, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                    attributes:@{NSFontAttributeName:
                                                                     [UIFont systemFontOfSize:12]}
                                                       context:nil].size;
        _labelCompanyHeight.constant = contentSize.height + 20;
        CompanyHeight = contentSize.height + 20;
    }
    

    [self setImages];
    
    for (id view in self.viewGuarantee.subviews) {
        [view removeFromSuperview];
    }
    
    NSDictionary *attr = _storeRzModel.attrs;
    float totalHeight;
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth- 20, 0)];
    NSInteger bigNum = 3;
    for (int a = 0; a < bigNum ; a++) {
        NSArray *valueArr = [NSArray array];
        NSString * value;
        if(a == 0){
            valueArr = attr[@"预约保障"];
            if (valueArr.count > 0) {
                value = valueArr[0];
            }
        }else if (a == 1){
            valueArr = attr[@"选材保障"];
            if (valueArr.count > 0) {
                value = valueArr[0];
            }
        }else{
            valueArr = attr[@"施工保障"];
            if (valueArr.count > 0) {
                value = valueArr[0];
            }
        }
        
        float valueheigth = 26;
        if (! [CommonUtil isEmpty:value ]) {
            CGSize contentSize = [value boundingRectWithSize:CGSizeMake(kScreenWidth -100 , MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                  attributes:@{NSFontAttributeName:
                                                                   [UIFont systemFontOfSize:13]}
                                                     context:nil].size;
            if (contentSize.height >26) {
                valueheigth = contentSize.height +8;
            }
            
        }
        
        UILabel *labelSmall = [[UILabel alloc] initWithFrame:CGRectMake(0, totalHeight, 70, valueheigth)];
        
        
        if(a == 0){
            labelSmall.text = @"预约保障";
        }else if (a == 1){
            labelSmall.text = @"选材保障";
        }else{
            labelSmall.text = @"施工保障";
        }
        labelSmall.font = [UIFont systemFontOfSize:13.0f];
        labelSmall.textColor = RGB(51, 51, 51);
        [view addSubview:labelSmall];
        labelSmall.textAlignment = UITextAlignmentCenter;
        
        UILabel *labelDetial = [[UILabel alloc] initWithFrame:CGRectMake(75, labelSmall.frame.origin.y, kScreenWidth - 100, valueheigth)];
        labelDetial.text = value;
        labelDetial.font = [UIFont systemFontOfSize:13.0f];
        labelDetial.textColor = RGB(51, 51, 51);
        labelDetial.numberOfLines = 0;
        [view addSubview:labelDetial];
        
        
        UIView *viewLineSu = [[UIView alloc] initWithFrame:CGRectMake(70, labelSmall.frame.origin.y, 1, valueheigth)];
        viewLineSu.backgroundColor = RGB(244, 244, 244);
        [view addSubview:viewLineSu];
        
        if (a != (bigNum-1)){
            UIView *viewLineHen = [[UIView alloc] initWithFrame:CGRectMake(0, labelSmall.frame.origin.y + valueheigth, kScreenWidth-20, 1)];
            viewLineHen.backgroundColor = RGB(244, 244, 244);
            [view addSubview:viewLineHen];
        }
        
        
        totalHeight += valueheigth;
    }
    
    view.height = totalHeight;
    _viewGuaranteeHeight.constant = totalHeight;
    [self.viewGuarantee addSubview:view];

    self.viewMain.constant = 600 + CompanyHeight - 162 +totalHeight -96 ;
}


//放大图片
- (void)ClickImageViewToEnlargeWithImageView:(UITapGestureRecognizer*)Tap{

    int Index = (int)Tap.view.tag;
    NSArray *honor =  _storeRzModel.honor;

    NSMutableArray *imgs = [NSMutableArray array];
    for ( NSDictionary *dic in honor) {
        [imgs addObject:[dic[@"pic_url"] description]];
    }
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    int i = 0;
    for(i = 0;i < imgs.count && i< 3;i++)
    {
        UIImageView *imageView = [self.view viewWithTag:i + 100];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = imgs[i];// 加载网络图片大图地址
        browseItem.smallImageView = imageView;// 小图
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:Index];
    bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
    [bvc showBrowseViewController];
}

// 返回
- (IBAction)btnClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 免费预约
- (IBAction)btnClickFreeAppiont:(id)sender {
    FreeFunctionViewController *view = [[FreeFunctionViewController alloc] initWithNibName:@"FreeFunctionViewController" bundle:nil];
    view.freeType = @"3";
    view.storeId = _storeId;
    [self.navigationController pushViewController:view animated:YES];
}


#pragma mark - private
//店铺认证信息
- (void)getStoreDetailData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    [parameters setValue:_storeId forKey:@"store_id"];
    __weak typeof(self) weakSelf = self;
    [GetMallStoreRzRequest requestWithParameters:parameters
                                   withCacheType:DataCacheManagerCacheTypeMemory
                               withIndicatorView:self.view
                               withCancelSubject:[GetMallStoreRzRequest getDefaultRequstName]
                                  onRequestStart:nil
                               onRequestFinished:^(CIWBaseDataRequest *request) {
                                   
                                   if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                       
                                       NSArray *List = [request.resultDic objectForKey:@"storeRz"];
                                       if(List.count > 0){
                                           weakSelf.storeRzModel = List[0];
                                           [self setMainUi];
                                       }

                                   
                                       
                                   }
                                   
                               }
                               onRequestCanceled:^(CIWBaseDataRequest *request) {
                                   
                               }
                                 onRequestFailed:^(CIWBaseDataRequest *request) {
                                     
                                 }];
}


@end
