//
//  WebViewController.m
//  wedding
//
//  Created by duanjycc on 14/11/17.
//  Copyright (c) 2014年 daoshun. All rights reserved.
//

#import "WebViewController.h"
#import "ScanViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "CommonUtils.h"
#import "UserAgentManager.h"
#import "ShareViewController.h"


#import "WXApi.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <MessageUI/MessageUI.h>
@interface WebViewController () <UIWebViewDelegate,MFMailComposeViewControllerDelegate, TencentSessionDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) JSContext *context;
@property(nonatomic,strong)UIView *popView;
@property(nonatomic,strong)UIView *thirdShareView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [CommonUtils addLoginTokenToWebCookiesWithHostName:@"jiehun.com.cn"];
    [CommonUtils addLoginTokenToWebCookiesWithHostName:@"jiabasha.com"];
    
    [UserAgentManager settingUserAgent];
    
    if (self.urlTitle) {
        self.labelTitle.text = self.urlTitle;
    }
    self.webView.delegate = self;

    self.urlString = [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *url = [[NSURL alloc] initWithString:self.urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    //test
//    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"testJSBrige.html" withExtension:nil];
//     [self.webView loadRequest:[NSURLRequest requestWithURL:fileURL]];
    
   
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *docTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (docTitle && !_urlTitle) {
        self.labelTitle.text = docTitle;
    }
    
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 打印异常
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
    };
    
    // 以 JSExport 协议关联 native 的方法
    self.context[@"native"] = self;
    
    __weak typeof(self) weakSelf = self;
    self.context[@"JsModelScan"] =
    ^()
    {
        [weakSelf startScan];
        
    };
//    self.context[@"native"] = self;
//    
//    __weak typeof(self) weakSelf1 = self;
//    self.context[@"JsModelpageState"] =
//    ^()
//    {
//        [weakSelf1 startScan];
//        
//    };
//    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    // 打印异常
//    self.context.exceptionHandler =
//    ^(JSContext *context, JSValue *exceptionValue)
//    {
//        context.exception = exceptionValue;
//        NSLog(@"%@", exceptionValue);
//    };
//    
//    // 以 JSExport 协议关联 native 的方法
//    NSLog(@"*****==%@", self.context);
//    self.context[@"native"] = self;
//    __weak typeof(self) weakSelf = self;
//    self.context[@"JsModelpageState"] =
//    ^(NSString *str, NSString *str1)
//    {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // UI更新代码
//            [weakSelf showThird];
//        });
//        
//    };
//    
//    
//    
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}

-(IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
 
}

// 扫一扫
- (void)startScan{
    ScanViewController *view = [[ScanViewController alloc] initWithNibName:@"ScanViewController" bundle:nil];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)showThird{
    
    //添加蒙版
    _popView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _popView.backgroundColor=[UIColor blackColor];
    _popView.alpha=0.6;
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
#pragma mark - 复制
- (void)pasteLink {
//    if(_arrStoreData.count == 0){
//        return;
//    }
//    BuildingStoreDetail *storeDetail =_arrStoreData[0];
//    NSString *url = [NSString stringWithFormat:@"http://h5.jiabasha.com/store/%@",_storeId];
//    NSString *title = storeDetail.storeName;
    NSDictionary *shareDic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"title", @"",@"logo",@"",@"link",nil];
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
//    BuildingStoreDetail *storeDetail =_arrStoreData[0];
//    NSString *url = [NSString stringWithFormat:@"http://h5.jiabasha.com/store/%@",_storeId];
//    NSString *title = storeDetail.storeName;
    NSDictionary *shareDic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"title", @"",@"logo",@"",@"link",nil];
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
//    BuildingStoreDetail *storeDetail =@"";
//    NSString *url = [NSString stringWithFormat:@"http://h5.jiabasha.com/store/%@",_storeId];
//    NSString *title = storeDetail.storeName;
    NSDictionary *shareDic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"title", @"",@"logo",@"",@"link",nil];
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

-(void)deleteView{
    [_popView removeFromSuperview];
    [_thirdShareView removeFromSuperview];
}

@end
