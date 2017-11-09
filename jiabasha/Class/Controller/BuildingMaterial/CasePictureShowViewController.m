//
//  CasePictureShowViewController.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/3.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ShareView.h"
#import "ExampleChild.h"
#import "ExampleDetail.h"
#import "ShareViewController.h"
#import "GetExampleChildRequest.h"
#import "FreeFunctionViewController.h"
#import "CasePictureShowViewController.h"

@interface CasePictureShowViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) ShareView *viewShare; // 分享
@property (strong, nonatomic) ExampleChild *exampleChild;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;


@end

@implementation CasePictureShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.pagingEnabled = YES;
    //[self setImageUi];
    [self geteExampleChildData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImageUi{
    self.labelTitle.text = _exampleChild.title;
    NSArray *imgs = _exampleChild.pics;
    NSInteger num = imgs.count;
    for (int a = 0; a < num; a++) {
        NSDictionary *picDic = imgs[a];
        
        NSString *desc = [picDic[@"pic_desc"] description];
        float descHeight = 0;
        if (desc != nil) {
            CGSize contentSize = [desc boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                 attributes:@{NSFontAttributeName:
                                                                  [UIFont systemFontOfSize:12.0f]}
                                                    context:nil].size;
            descHeight =  contentSize.height+10;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(a *kScreenWidth, 0, kScreenWidth,  kScreenHeight - 114 -descHeight)];
 
        imageView.backgroundColor = [UIColor blackColor];
    
        UILabel *labelProfile = [[UILabel alloc] initWithFrame:CGRectMake(a *kScreenWidth + 10, kScreenHeight - 114-descHeight, kScreenWidth -20, descHeight)];
        labelProfile.numberOfLines = 0;
        labelProfile.font = [UIFont systemFontOfSize:12.0f];
        labelProfile.textColor = RGB(51, 51, 51);
        // imageView.contentMode = UIViewContentModeScaleToFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[picDic[@"img_url"] description]] placeholderImage:[UIImage imageNamed:PLUSPLACEHOLDERIMG]];

          labelProfile.text = desc;
        [self.scrollView addSubview:imageView];
        [self.scrollView addSubview:labelProfile];
       
    }
    
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth *num, kScreenHeight - 114)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 返回
- (IBAction)btnClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 免费预约
- (IBAction)btnClickFreeAppiont:(id)sender {
    FreeFunctionViewController *view = [[FreeFunctionViewController alloc] initWithNibName:@"FreeFunctionViewController" bundle:nil];
    view.freeType = @"3";
    view.storeId = _exampleChild.storeId;
    [self.navigationController pushViewController:view animated:YES];
}

// 分享
- (IBAction)btnClickShare:(id)sender {
    
    if (_exampleDetail == nil) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://h5.jiabasha.com/album/%@",_exampleDetail.albumId];
    NSString *title = _exampleDetail.albumName;
    NSDictionary *shareDic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title", _exampleDetail.showImgUrl,@"logo",url,@"link",nil];
    
    ShareViewController *viewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    viewController.shareContent = shareDic;
    
    UIViewController* controller = self.view.window.rootViewController;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        viewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }else{
        controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    [controller presentViewController:viewController animated:YES completion:^{
        viewController.view.superview.backgroundColor = [UIColor clearColor];
    }];
}

//案例子相册
- (void)geteExampleChildData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_childId forKey:@"child_id"];
    __weak typeof(self) weakSelf = self;
    [GetExampleChildRequest requestWithParameters:parameters
                                     withCacheType:DataCacheManagerCacheTypeMemory
                                 withIndicatorView:self.view
                                 withCancelSubject:[GetExampleChildRequest getDefaultRequstName]
                                    onRequestStart:nil
                                 onRequestFinished:^(CIWBaseDataRequest *request) {
                                     
                                     if ([RESPONSE_OK isEqualToString:request.errCode] || [@"OK" isEqualToString:request.errCode]) {
                                      NSArray *arr  = [request.resultDic objectForKey:@"exampleChild"];
                                         if (arr.count >0) {
                                             weakSelf.exampleChild  = arr[0];
                                             [self setImageUi];
                                         }
                                         
                                     }
                                     
                                     
                                 }
                                 onRequestCanceled:^(CIWBaseDataRequest *request) {
                                     
                                 }
                                   onRequestFailed:^(CIWBaseDataRequest *request) {
                                       
                                   }];
}


@end
