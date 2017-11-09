//
//  ShareViewController.m
//  wedding
//
//  Created by Jianyong Duan on 14/12/10.
//  Copyright (c) 2014年 daoshun. All rights reserved.
//

#import "ShareViewController.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <MessageUI/MessageUI.h>

@interface ShareViewController () <MFMailComposeViewControllerDelegate, TencentSessionDelegate>

@property (nonatomic, retain) TencentOAuth *oauth;
@property (weak, nonatomic) IBOutlet UIButton *ShadeBUtton;
@property (weak, nonatomic) IBOutlet UIView *ShareView;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       // Do any additional setup after loading the view from its nib.
//    NSMutableArray *array = [NSMutableArray array];
//    
    CGFloat _width = [UIScreen mainScreen].bounds.size.width;
    CGFloat rectX = (_width - 60 *4 - 40)/3;
    
    //水平方向布局(从左向右)
    self.leftForFriends.constant = rectX;
    self.leftForWeibo.constant = rectX;

    //QQ注册
    _oauth = [[TencentOAuth alloc] initWithAppId:kAppID_QQ
                                     andDelegate:self];
    
//    NSArray *permissions = [NSArray arrayWithObjects:@"all", nil];
//    [_oauth authorize:permissions];
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
- (IBAction)closeClick:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareClick:(UIControl *)sender {
    switch (sender.tag) {
        case 0:
            //微信好友
            [self weixinShare:WXSceneSession];
            break;
            
        case 1:
            //微信朋友圈
            [self weixinShare:WXSceneTimeline];
            break;
            
        case 2:
            //新浪微博
            [self weiboShare];
            break;
            
        case 3:
            //QQ
            [self tencentShare:0];
            break;
            
        case 4:
            //QQ空间
            [self tencentShare:1];
            break;
            
        case 5:
//            //电子邮件
//            [self emailShare];
            //复制链接
            [self pasteLink];
            break;
            
        default:
            break;
    }
}

#pragma mark - 微信好友 微信朋友圈
- (void) weixinShare:(int)scene {
    if (![WXApi isWXAppInstalled]) {
        [MessageView displayMessage:@"没有安装微信"];
        return;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _shareContent[@"title"];
    message.description = _shareContent[@"content"];
    UIImage *image;
    if([CommonUtil isEmpty:_shareContent[@"logo"]]){
        image = [UIImage imageNamed:@"app_Icon"];
    }else{
        NSURL *url = [NSURL URLWithString:_shareContent[@"logo"]];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }
  
    [message setThumbImage:[self imageWithImageSimple:image scaledToSize:CGSizeMake(99, 99) ]];

    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = _shareContent[@"link"];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 新浪微博
- (void)weiboShare {
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSURL *url = [NSURL URLWithString:_shareContent[@"logo"]];
    
    WBMessageObject *message = [WBMessageObject message];
    message.text = _shareContent[@"content"];
    
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = [NSData dataWithContentsOfURL:url];
    message.imageObject = imageObject;
    
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = [NSString stringWithFormat:NSLocalizedString(@"identifier%.0f", nil), [[NSDate date] timeIntervalSince1970]];
    webpage.title = _shareContent[@"title"];
    webpage.description = _shareContent[@"content"];
    
    webpage.thumbnailData = [NSData dataWithContentsOfURL:url];
    
    webpage.webpageUrl = _shareContent[@"link"];
    
    message.mediaObject = webpage;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI_Weibo;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken];
//    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - QQ QQ空间
- (void) tencentShare:(int)type {
    QQApiObject *_qqApiObject;
    
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:_shareContent[@"link"] ? : @""]
                                                        title:_shareContent[@"title"] ? : @""
                                                  description:_shareContent[@"content"] ? : @""
                                              previewImageURL:[NSURL URLWithString:_shareContent[@"logo"] ? : @""]];
//    uint64_t cflag = 1;
//    [newsObj setCflag:cflag];
    
    _qqApiObject = newsObj;
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:_qqApiObject];
    QQApiSendResultCode sent = 0;
    if (0 == type)
    {
        //分享到QQ
        sent = [QQApiInterface sendReq:req];
    }
    else
    {
        //分享到QZone
        sent = [QQApiInterface SendReqToQZone:req];
    }
    [self handleSendResult:sent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeClick:) name:@"QQResp" object:nil];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            [MessageView displayMessage:@"App未注册"];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            [MessageView displayMessage:@"发送参数错误"];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            [MessageView displayMessage:@"未安装手机QQ"];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            [MessageView displayMessage:@"API接口不支持"];
            break;
        }
        case EQQAPISENDFAILD:
        {
            [MessageView displayMessage:@"发送失败"];
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            [MessageView displayMessage:@"空间分享不支持纯文本分享，请使用图文分享"];
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            [MessageView displayMessage:@"空间分享不支持纯图片分享，请使用图文分享"];
            break;
        }
        default:
        {
            break;
        }
    }
}

//- (NSMutableDictionary *)currentNavContext
//{
//    UINavigationController *navCtrl = [self navigationController];
//    NSMutableDictionary *context = objc_getAssociatedObject(navCtrl, objc_unretainedPointer(@"currentNavContext"));
//    if (nil == context)
//    {
//        context = [NSMutableDictionary dictionaryWithCapacity:3];
//        objc_setAssociatedObject(navCtrl, objc_unretainedPointer(@"currentNavContext"), context, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    
//    return context;
//}
//
//- (uint64_t)shareControlFlags
//{
//    NSDictionary *context = [self currentNavContext];
//    __block uint64_t cflag = 0;
//    [context enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        if ([obj isKindOfClass:[NSNumber class]] &&
//            [key isKindOfClass:[NSString class]] &&
//            [key hasPrefix:@"kQQAPICtrlFlag"])
//        {
//            cflag |= [obj unsignedIntValue];
//        }
//    }];
//    
//    return cflag;
//}

#pragma mark - 电子邮件
- (void)emailShare {
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject:_shareContent[@"title"]];
    
    // 添加一张图片
    NSURL *url = [NSURL URLWithString:_shareContent[@"logo"]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    [mailPicker addAttachmentData: imageData mimeType:@"png" fileName: @"xiyan_logo.png"];
    
    NSString *emailBody = [NSString stringWithFormat:@"%@ %@", _shareContent[@"content"], _shareContent[@"link"]];
    [mailPicker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:mailPicker animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [controller dismissViewControllerAnimated:NO completion:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 复制
- (void)pasteLink {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _shareContent[@"link"];
    
    [MessageView displayMessage:@"已经复制到剪贴板"];
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
