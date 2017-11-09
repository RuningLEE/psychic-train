//
//  VIPViewController.m
//  jiabasha
//
//  Created by zhangzt on 2016/12/30.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "VIPViewController.h"
#import "Masonry.h"
#import "GetLevelListRequest.h"
#import "UserAgentManager.h"
#import "CommonUtils.h"

@interface VIPViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHead;
@property (weak, nonatomic) IBOutlet UIView *viewTopContent;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelVipTitle;
@property (strong, nonatomic) UIImageView *imageviewNewVip;
@property (strong, nonatomic) UIImageView *imageviewOldVip;
@property (strong, nonatomic) UIImageView *imageviewVip;
@property (strong, nonatomic) UIImageView *imageviewGCVip;
@property (strong, nonatomic) UILabel *labelNewVip;
@property (strong, nonatomic) UILabel *labelOldVip;
@property (strong, nonatomic) UILabel *labelVip;
@property (strong, nonatomic) UILabel *labelGCVip;
@property (strong, nonatomic) UIImageView *imageviewbottomIcon;
@property (strong, nonatomic) UIView *lineFir;
@property (strong, nonatomic) UIView *lineSec;
@property (strong, nonatomic) UIView *lineTir;
@property (strong, nonatomic) NSArray *arrayRelust;
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (strong, nonatomic) CIWMaskActivityView *activityView;
@end

@implementation VIPViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_imageViewHead sd_setImageWithURL:[NSURL URLWithString:DATA_ENV.userInfo.user.faceUrl] placeholderImage:[UIImage imageNamed:@"未登录头像-1"]];
    _labelName.text = DATA_ENV.userInfo.user.uname;
    NSLog(@"%@",DATA_ENV.userInfo.user);
    [_mainWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#F6F6F6'"];
    [_mainWebView setBackgroundColor:[UIColor clearColor]];
    [_mainWebView setOpaque:NO];
    _mainWebView.scrollView.scrollEnabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getLevelDetailRequest];
    [CommonUtils addLoginTokenToWebCookiesWithHostName:@"jiehun.com.cn"];
    [CommonUtils addLoginTokenToWebCookiesWithHostName:@"jiabasha.com"];
    
    [UserAgentManager settingUserAgent];
    _mainWebView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    _activityView = [CIWMaskActivityView loadFromXib];
    [_activityView showInView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityView hide];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityView hide];
}

- (NSArray *)arrayRelust
{
    if (_arrayRelust == nil) {
        _arrayRelust = [NSArray array];
    }
    return _arrayRelust;
}

#pragma mark - Request

- (void)getLevelDetailRequest{
    //"city_id": "110900","phone": "18201631471","app_id":"100","app_secret":"09f8dcf852d1254c490342c1a05db1dc"
    __weak typeof(self)weakSelf = self;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"18201631471",@"phone",nil];
    [GetLevelListRequest requestWithParameters:param withCacheType:0 withIndicatorView:self.view withCancelSubject:[GetLevelListRequest getDefaultRequstName] onRequestStart:^(CIWBaseDataRequest *request) {
        
    } onRequestFinished:^(CIWBaseDataRequest *request) {
        if ([request.errCode isEqualToString:RESPONSE_OK]) {
            NSLog(@"%@",request.resultDic);
            weakSelf.arrayRelust = [request.resultDic objectForKey:@"data"];
            [self setup];
        }
    } onRequestCanceled:^(CIWBaseDataRequest *request) {
        
    } onRequestFailed:^(CIWBaseDataRequest *request) {
        
    }];
}

- (void)setup{
    _imageViewHead.layer.borderColor = RGB(237, 219, 252).CGColor;
    _imageViewHead.layer.borderWidth = 2.5;
    _imageViewHead.layer.masksToBounds = YES;
    _imageViewHead.layer.cornerRadius = 35;
    //判断会员情况进行布局
    CGFloat lineW   = (kScreenWidth-60-4*32)/3;
    CGFloat newVipX = 30;
    CGFloat oldVipX = 30+32+lineW;
    CGFloat vipX    = oldVipX+32+lineW;
    CGFloat gcvipX  = vipX+32+lineW;
    //新会员
    _imageviewNewVip = [[UIImageView alloc]init];
    _imageviewNewVip.tag = 1;
    _imageviewNewVip.userInteractionEnabled = YES;
    [_imageviewNewVip addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageVipClickedWithTap:)]];
    [_viewTopContent addSubview:_imageviewNewVip];
    [_imageviewNewVip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labelName.mas_bottom).offset(15);
        make.left.mas_equalTo(newVipX).with.priorityHigh();
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    _labelNewVip = [[UILabel alloc]init];
    _labelNewVip.text = @"新会员";
    _labelNewVip.textColor = RGB(96, 25, 134);
    _labelNewVip.font = [UIFont systemFontOfSize:11];
    [_viewTopContent addSubview:_labelNewVip];
    [_labelNewVip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageviewNewVip.mas_bottom).offset(5);
        make.centerX.mas_equalTo(_imageviewNewVip.mas_centerX);
    }];
    //老会员
    _imageviewOldVip = [[UIImageView alloc]init];
    _imageviewOldVip.tag = 2;
    _imageviewOldVip.userInteractionEnabled = YES;
    [_imageviewOldVip addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageVipClickedWithTap:)]];
    [_viewTopContent addSubview:_imageviewOldVip];
    [_imageviewOldVip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_imageviewNewVip.mas_centerY);
        make.left.mas_equalTo(oldVipX).with.priorityHigh();
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    _labelOldVip = [[UILabel alloc]init];
    _labelOldVip.text = @"老会员";
    _labelOldVip.textColor = RGB(96, 25, 134);
    _labelOldVip.font = [UIFont systemFontOfSize:11];
    [_viewTopContent addSubview:_labelOldVip];
    [_labelOldVip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageviewOldVip.mas_bottom).offset(5);
        make.centerX.mas_equalTo(_imageviewOldVip.mas_centerX);
    }];
    //vip会员
    _imageviewVip = [[UIImageView alloc]init];
    _imageviewVip.tag = 3;
    _imageviewVip.userInteractionEnabled = YES;
    [_imageviewVip addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageVipClickedWithTap:)]];
    [_viewTopContent addSubview:_imageviewVip];
    [_imageviewVip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_imageviewNewVip.mas_centerY);
        make.left.mas_equalTo(vipX).with.priorityHigh();
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    _labelVip = [[UILabel alloc]init];
    _labelVip.text = @"VIP会员";
    _labelVip.textColor = RGB(96, 25, 134);
    _labelVip.font = [UIFont systemFontOfSize:11];
    [_viewTopContent addSubview:_labelVip];
    [_labelVip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageviewVip.mas_bottom).offset(5);
        make.centerX.mas_equalTo(_imageviewVip.mas_centerX);
    }];
    //金卡会员
    _imageviewGCVip = [[UIImageView alloc]init];
    _imageviewGCVip.tag = 4;
    _imageviewGCVip.userInteractionEnabled = YES;
    [_imageviewGCVip addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageVipClickedWithTap:)]];
    [_viewTopContent addSubview:_imageviewGCVip];
    [_imageviewGCVip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_imageviewNewVip.mas_centerY);
        make.left.mas_equalTo(gcvipX).with.priorityHigh();
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    _labelGCVip = [[UILabel alloc]init];
    _labelGCVip.text = @"金卡会员";
    _labelGCVip.textColor = RGB(96, 25, 134);
    _labelGCVip.font = [UIFont systemFontOfSize:11];
    [_viewTopContent addSubview:_labelGCVip];
    [_labelGCVip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageviewGCVip.mas_bottom).offset(5);
        make.centerX.mas_equalTo(_imageviewGCVip.mas_centerX);
    }];
    
    //布局三条线
    if ([DATA_ENV.userInfo.user.userLevel isEqualToString:@"new"]) {//新会员
        _imageviewNewVip.image = [UIImage imageNamed:@"新会员B"];
        _imageviewOldVip.image = [UIImage imageNamed:@"老会员"];
        _imageviewVip.image = [UIImage imageNamed:@"Vip会员"];
        _imageviewGCVip.image = [UIImage imageNamed:@"金卡会员"];
        _labelVipTitle.text = @"新会员特权";
        _labelNewVip.textColor = RGB(242, 205, 0);
        [_mainWebView loadHTMLString:[[self.arrayRelust objectAtIndex:0] objectForKey:@"content"] baseURL:nil];
        
        _lineFir = [[UIView alloc]init];
        _lineFir.backgroundColor = RGB(96, 25, 134);
        [_viewTopContent addSubview:_lineFir];
        [_lineFir mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageviewNewVip.mas_right);
            make.width.mas_equalTo(lineW);
            make.height.mas_equalTo(2);
            make.centerY.mas_equalTo(_imageviewNewVip.mas_centerY);
        }];
        
        _lineSec = [[UIView alloc]init];
        _lineSec.backgroundColor = RGB(96, 25, 134);
        [_viewTopContent addSubview:_lineSec];
        [_lineSec mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageviewOldVip.mas_right);
            make.right.mas_equalTo(_imageviewVip.mas_left);
            make.height.mas_equalTo(2);
            make.centerY.mas_equalTo(_imageviewNewVip.mas_centerY);
        }];
        
        _lineTir = [[UIView alloc]init];
        _lineTir.backgroundColor = RGB(96, 25, 134);
        [_viewTopContent addSubview:_lineTir];
        [_lineTir mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageviewVip.mas_right);
            make.right.mas_equalTo(_imageviewGCVip.mas_left);
            make.height.mas_equalTo(2);
            make.centerY.mas_equalTo(_imageviewNewVip.mas_centerY);
        }];
        
        //布局进度线
        UIView *yellowLine = [[UIView alloc]init];
        yellowLine.backgroundColor = RGB(242, 205, 0);
        [_viewTopContent addSubview:yellowLine];
        [yellowLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(lineW/2);
            make.top.left.bottom.mas_equalTo(_lineFir);
        }];
        
        //底部三角
        _imageviewbottomIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vip_bottom_icon"]];
        [_viewTopContent addSubview:_imageviewbottomIcon];
        [_imageviewbottomIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_imageviewNewVip.mas_centerX).with.priorityMedium();
            make.bottom.mas_equalTo(_viewTopContent.mas_bottom);
        }];

    } else if ([DATA_ENV.userInfo.user.userLevel isEqualToString:@"old"]){
        _imageviewNewVip.image = [UIImage imageNamed:@"新会员"];
        _imageviewOldVip.image = [UIImage imageNamed:@"老会员B"];
        _imageviewVip.image = [UIImage imageNamed:@"Vip会员"];
        _imageviewGCVip.image = [UIImage imageNamed:@"金卡会员"];
        _labelOldVip.textColor = RGB(242, 205, 0);
        _labelVipTitle.text = @"老会员特权";
        [_mainWebView loadHTMLString:[[self.arrayRelust objectAtIndex:1] objectForKey:@"content"] baseURL:nil];
        
        _lineFir = [[UIView alloc]init];
        _lineFir.backgroundColor = RGB(242, 205, 0);
        [_viewTopContent addSubview:_lineFir];
        [_lineFir mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageviewNewVip.mas_right);
            make.right.mas_equalTo(_imageviewOldVip.mas_left);
            make.height.mas_equalTo(2);
            make.centerY.mas_equalTo(_imageviewNewVip.mas_centerY);
        }];
        
        _lineSec = [[UIView alloc]init];
        _lineSec.backgroundColor = RGB(96, 25, 134);
        [_viewTopContent addSubview:_lineSec];
        [_lineSec mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageviewOldVip.mas_right);
            make.right.mas_equalTo(_imageviewVip.mas_left);
            make.height.mas_equalTo(2);
            make.centerY.mas_equalTo(_imageviewNewVip.mas_centerY);
        }];
        
        //布局进度线
        UIView *yellowLine = [[UIView alloc]init];
        yellowLine.backgroundColor = RGB(242, 205, 0);
        [_viewTopContent addSubview:yellowLine];
        [yellowLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(lineW/2);
            make.top.left.bottom.mas_equalTo(_lineSec);
        }];
        
        _lineTir = [[UIView alloc]init];
        _lineTir.backgroundColor = RGB(96, 25, 134);
        [_viewTopContent addSubview:_lineTir];
        [_lineTir mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageviewVip.mas_right);
            make.right.mas_equalTo(_imageviewGCVip.mas_left);
            make.height.mas_equalTo(2);
            make.centerY.mas_equalTo(_imageviewNewVip.mas_centerY);
        }];
        
        //底部三角
        _imageviewbottomIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vip_bottom_icon"]];
        [_viewTopContent addSubview:_imageviewbottomIcon];
        [_imageviewbottomIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_imageviewOldVip.mas_centerX).with.priorityMedium();
            make.bottom.mas_equalTo(_viewTopContent.mas_bottom);
        }];

    } else if ([DATA_ENV.userInfo.user.userLevel isEqualToString:@"vip"]){
        _imageviewNewVip.image = [UIImage imageNamed:@"新会员"];
        _imageviewOldVip.image = [UIImage imageNamed:@"老会员"];
        _imageviewVip.image = [UIImage imageNamed:@"Vip会员B"];
        _imageviewGCVip.image = [UIImage imageNamed:@"金卡会员"];
        _labelVip.textColor = RGB(242, 205, 0);
        _labelVipTitle.text = @"Vip会员特权";
        [_mainWebView loadHTMLString:[[self.arrayRelust objectAtIndex:2] objectForKey:@"content"] baseURL:nil];
        
        _lineFir = [[UIView alloc]init];
        _lineFir.backgroundColor = RGB(242, 205, 0);
        [_viewTopContent addSubview:_lineFir];
        [_lineFir mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageviewNewVip.mas_right);
            make.right.mas_equalTo(_imageviewOldVip.mas_left);
            make.height.mas_equalTo(2);
            make.centerY.mas_equalTo(_imageviewNewVip.mas_centerY);
        }];
        
        _lineSec = [[UIView alloc]init];
        _lineSec.backgroundColor = RGB(242, 205, 0);
        [_viewTopContent addSubview:_lineSec];
        [_lineSec mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageviewOldVip.mas_right);
            make.right.mas_equalTo(_imageviewVip.mas_left);
            make.height.mas_equalTo(2);
            make.centerY.mas_equalTo(_imageviewNewVip.mas_centerY);
        }];
        
        _lineTir = [[UIView alloc]init];
        _lineTir.backgroundColor = RGB(96, 25, 134);
        [_viewTopContent addSubview:_lineTir];
        [_lineTir mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageviewVip.mas_right);
            make.right.mas_equalTo(_imageviewGCVip.mas_left);
            make.height.mas_equalTo(2);
            make.centerY.mas_equalTo(_imageviewNewVip.mas_centerY);
        }];
        
        //布局进度线
        UIView *yellowLine = [[UIView alloc]init];
        yellowLine.backgroundColor = RGB(242, 205, 0);
        [_viewTopContent addSubview:yellowLine];
        [yellowLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(lineW/2);
            make.top.left.bottom.mas_equalTo(_lineTir);
        }];
        
        //底部三角
        _imageviewbottomIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vip_bottom_icon"]];
        [_viewTopContent addSubview:_imageviewbottomIcon];
        [_imageviewbottomIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_imageviewVip.mas_centerX).with.priorityMedium();
            make.bottom.mas_equalTo(_viewTopContent.mas_bottom);
        }];

    } else {//gold
        _imageviewNewVip.image = [UIImage imageNamed:@"新会员"];
        _imageviewOldVip.image = [UIImage imageNamed:@"老会员"];
        _imageviewVip.image = [UIImage imageNamed:@"Vip会员"];
        _imageviewGCVip.image = [UIImage imageNamed:@"金卡会员B"];
        _labelVipTitle.text = @"金卡会员特权";
        _labelGCVip.textColor = RGB(242, 205, 0);
        [_mainWebView loadHTMLString:[[self.arrayRelust objectAtIndex:3] objectForKey:@"content"] baseURL:nil];
        
        _lineFir = [[UIView alloc]init];
        _lineFir.backgroundColor = RGB(242, 205, 0);
        [_viewTopContent addSubview:_lineFir];
        [_lineFir mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageviewNewVip.mas_right);
            make.right.mas_equalTo(_imageviewOldVip.mas_left);
            make.height.mas_equalTo(2);
            make.centerY.mas_equalTo(_imageviewNewVip.mas_centerY);
        }];
        
        _lineSec = [[UIView alloc]init];
        _lineSec.backgroundColor = RGB(242, 205, 0);
        [_viewTopContent addSubview:_lineSec];
        [_lineSec mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageviewOldVip.mas_right);
            make.right.mas_equalTo(_imageviewVip.mas_left);
            make.height.mas_equalTo(2);
            make.centerY.mas_equalTo(_imageviewNewVip.mas_centerY);
        }];
        
        _lineTir = [[UIView alloc]init];
        _lineTir.backgroundColor = RGB(242, 205, 0);
        [_viewTopContent addSubview:_lineTir];
        [_lineTir mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageviewVip.mas_right);
            make.right.mas_equalTo(_imageviewGCVip.mas_left);
            make.height.mas_equalTo(2);
            make.centerY.mas_equalTo(_imageviewNewVip.mas_centerY);
        }];
        
        //底部三角
        _imageviewbottomIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vip_bottom_icon"]];
        [_viewTopContent addSubview:_imageviewbottomIcon];
        [_imageviewbottomIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_imageviewGCVip.mas_centerX).with.priorityMedium();
            make.bottom.mas_equalTo(_viewTopContent.mas_bottom);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imageVipClickedWithTap:(UIGestureRecognizer *)tap{
    switch (tap.view.tag) {
        case 1:
        {
            [self.viewTopContent layoutIfNeeded];
            [_imageviewbottomIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_imageviewNewVip.mas_centerX).with.priorityMedium();
                make.bottom.mas_equalTo(_viewTopContent.mas_bottom);
            }];
            [UIView animateWithDuration:0.2 animations:^{
               
                [self.viewTopContent layoutIfNeeded];
            }];
            _labelVipTitle.text = @"新会员特权";
            [_mainWebView loadHTMLString:[[self.arrayRelust objectAtIndex:0] objectForKey:@"content"] baseURL:nil];
        }
            break;
        case 2:
        {
            [self.viewTopContent layoutIfNeeded];
            [_imageviewbottomIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_imageviewOldVip.mas_centerX).with.priorityMedium();
                make.bottom.mas_equalTo(_viewTopContent.mas_bottom);
            }];
            [UIView animateWithDuration:0.2 animations:^{
                [self.viewTopContent layoutIfNeeded];
            }];
            _labelVipTitle.text = @"老会员特权";
            [_mainWebView loadHTMLString:[[self.arrayRelust objectAtIndex:1] objectForKey:@"content"] baseURL:nil];        }
            break;
        case 3:
        {
            [self.viewTopContent layoutIfNeeded];
            [_imageviewbottomIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_imageviewVip.mas_centerX).with.priorityMedium();
                make.bottom.mas_equalTo(_viewTopContent.mas_bottom);
            }];
            [UIView animateWithDuration:0.2 animations:^{
                [self.viewTopContent layoutIfNeeded];
            }];
            _labelVipTitle.text = @"VIP会员特权";
            [_mainWebView loadHTMLString:[[self.arrayRelust objectAtIndex:2] objectForKey:@"content"] baseURL:nil];        }
            break;
        case 4:
        {
            [self.viewTopContent layoutIfNeeded];
            [_imageviewbottomIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_imageviewGCVip.mas_centerX).with.priorityMedium();
                make.bottom.mas_equalTo(_viewTopContent.mas_bottom);
            }];
            [UIView animateWithDuration:0.2 animations:^{
                [self.viewTopContent layoutIfNeeded];
            }];
            _labelVipTitle.text = @"金卡会员特权";
            [_mainWebView loadHTMLString:[[self.arrayRelust objectAtIndex:3] objectForKey:@"content"] baseURL:nil];        }
            break;
            
        default:
            break;
    }
}

#pragma mark - ButtonClick
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
