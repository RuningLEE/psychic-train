//
//  AppDelegate.m
//  jiabasha
//
//  Created by Jianyong Duan on 2016/12/26.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MyNaviControllerViewController.h"

#import "City.h"
#import "SelectCityViewController.h"

#import "LoginViewController.h"
#import "GuideViewController.h"

#import "GeTuiSdk.h"     // GetuiSdk头文件应用
#import <UserNotifications/UserNotifications.h>

#import "WXApi.h"  // 微信SDK-
#import "MessageViewController.h"

#import "GetContentRequest.h"
#import "AdContent.h"
#import "AdViewController.h"
#import "WebViewController.h"
#import "Growing.h"
#import "UserAgentManager.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#define kGtAppId           @"jp5W2m31oP75qE6j5G8neA"
#define kGtAppKey          @"attMBqRSyl9M79uqzpdEI5"
#define kGtAppSecret       @"vQRUmSfvKR91Q4XcclXNIA"

@interface AppDelegate ()<UIApplicationDelegate, GeTuiSdkDelegate, UNUserNotificationCenterDelegate,WXApiDelegate>{
    BMKMapManager *_mapManager;
}


@property (strong, nonatomic) MyNaviControllerViewController *navi;
@property (strong, nonatomic) GuideViewController *guideViewController;
@property (strong, nonatomic) AdViewController *adViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *mapKey = @"9xoSlqffGIHD5ICXfrpzScLPjA3wUH5s";
    _mapManager = [[BMKMapManager alloc]init];
    
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [_mapManager start:mapKey generalDelegate:nil];
    if (ret) {
        NSLog(@"百度引擎设置成功！");

    }
    
    // 启动GrowingIO
    
    [Growing startWithAccountId:@"93e7682bdaf0f33a"];
    // 其他配置
    // 开启Growing调试日志 可以开启日志
     [Growing setEnableLog:YES];
    
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    [self registerRemoteNotification];
    
    /* 向微信注册 */
    BOOL DD = [WXApi registerApp:kAppID_Weixin];

    // Override point for customization after application launch.
    self.window  = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    //选择城市
    City *city = DATA_ENV.city;
    if (city == nil) {
        //城市未选择的情况下
        SelectCityViewController *selectCity = [[SelectCityViewController alloc] initWithNibName:@"SelectCityViewController" bundle:nil];
        self.navi = [[MyNaviControllerViewController alloc] initWithRootViewController:selectCity];
    } else {
        
        _MyTabBarController  = [[JZMainTabController alloc] initWithNibName:@"JZMainTabController" bundle:nil];
        self.navi = [[MyNaviControllerViewController alloc] initWithRootViewController:_MyTabBarController];
    }

    self.window.rootViewController = _navi;
    [_navi setNavigationBarHidden:YES];
    [self.window makeKeyAndVisible];
    
    //登录监听
    if (!DATA_ENV.isLogin) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLogin) name:@"needlogin" object:nil];
    }
    
    //程序在没有设置推送开关的情况下设置为开
    if ([CommonUtil isEmpty:[CommonUtil getObjectFromUD:@"getuiKey"]]) {
        [CommonUtil saveObjectToUD:@"YES" key:@"getuiKey"];
    }
    
    //引导图
    if (![[USER_DEFAULT objectForKey:@"Guide"] boolValue])
    {
        [USER_DEFAULT setObject:[NSNumber numberWithBool:YES] forKey:@"Guide"];
        [USER_DEFAULT synchronize];
        
        self.guideViewController = [[GuideViewController alloc] init];
        self.guideViewController.view.frame = self.window.bounds;
        [self.window addSubview:self.guideViewController.view];
    } else {
        //开屏广告
        NSDictionary *dicData = [USER_DEFAULT objectForKey:@"StartAdContent"];

        if (dicData && [dicData isKindOfClass:[NSDictionary class]]) {
            AdContent *adContent = [AdContent new];
            adContent.contentPicUrl = dicData[@"contentPicUrl"];
            adContent.contentUrl = dicData[@"contentUrl"];
            
            self.adViewController = [[AdViewController alloc] init];
            self.adViewController.adContent = adContent;
            self.adViewController.view.frame = self.window.bounds;
            [self.window addSubview:self.adViewController.view];
        }
    }

    //取开屏广告图
    [self getAdContent:@"open_ads_pictures_1080x1920"];
    
    [UserAgentManager settingUserAgent];
    
    return YES;
}

//取广告数据
- (void)getAdContent:(NSString *)name {
    [GetContentRequest requestWithParameters:@{@"ad_location_name":name}
                           withIndicatorView:nil
                              onRequestStart:nil
                           onRequestFinished:^(CIWBaseDataRequest *request) {
                               if ([RESPONSE_OK isEqualToString:request.errCode]) {
                                   
                                   if ([request.resultDic objectForKey:KEY_ADCONTENT]) {
                                       
                                       NSArray *array = [request.resultDic objectForKey:KEY_ADCONTENT];
                                       
                                       if (array.count > 0) {
                                           AdContent *adContent = array[0];
                                           NSDictionary *dic = @{@"contentPicUrl":adContent.contentPicUrl?:@"",
                                                                 @"contentUrl":adContent.contentUrl?:@""};
                                           
                                           [USER_DEFAULT setObject:dic forKey:@"StartAdContent"];
                                           [USER_DEFAULT synchronize];
                                           
                                           [[SDWebImageDownloader sharedDownloader]
                                            downloadImageWithURL:[NSURL URLWithString:adContent.contentUrl]
                                            options:4
                                            progress:nil
                                            completed:nil];
                                       }
                                       
                                   }
                               }
                           }
                           onRequestCanceled:nil
                             onRequestFailed:nil];
    
}

- (UINavigationController *)getNavigationController {
    return self.navi;
}

- (void)guideViewBeginClick {
    self.guideViewController.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.guideViewController.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.guideViewController.view removeFromSuperview];
        self.guideViewController = nil;
    }];
}

//开屏广告图
- (void)startAdViewBeginClick:(NSString *)urlstring {
    
    self.adViewController.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.adViewController.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.adViewController.view removeFromSuperview];
        self.adViewController = nil;
    }];
    
    if (urlstring.length > 0) {
        WebViewController *viewController = [[WebViewController alloc] init];
        viewController.urlString = urlstring;
        [self.navi pushViewController:viewController animated:YES];
    }
}

/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

/*
 统计APNs通知的点击数 通知响应
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    if ([[self.navi.viewControllers lastObject] isKindOfClass:[MessageViewController class]]) {
        
    } else {
        MessageViewController *message = [[MessageViewController alloc]init];
        [self.navi pushViewController:message animated:NO];
    }
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}

#endif

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)showLogin {
    LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navi pushViewController:viewController animated:YES];
}

#pragma mark - 微信 回调方法

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        [ [NSNotificationCenter defaultCenter] postNotificationName:@"succesShare" object:nil];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        [ [NSNotificationCenter defaultCenter] postNotificationName:@"succesShare" object:nil];
    }
    
}

/* 微信请求消息结果 */
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        NSInteger errCode = resp.errCode;
        if (errCode == 0) {
            [CommonUtil showAlertView:@"分享成功"];
            
        }else {
            [CommonUtil showAlertView:@"分享失败"];
        }
    }else if([resp isKindOfClass:[SendAuthResp class]])
    {
        
        
    }
}

/* 微信使用 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *urlString = url.absoluteString;
    if ([urlString hasPrefix:kAppID_Weixin]) {          // 微信调用
        BOOL isSuc = [WXApi handleOpenURL:url delegate:self];   // 微信回调
        return  isSuc;
    }
    if ([Growing handleUrl:url])
    {
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *urlString = url.absoluteString;
    
    if ([urlString hasPrefix:kAppID_Weixin]) {          // 微信调用
        BOOL isSuc = [WXApi handleOpenURL:url delegate:self];   // 微信回调
        return  isSuc;
    }
    if ([Growing handleUrl:url])
    {
        return YES;
    }
    
    return NO;
}


@end
