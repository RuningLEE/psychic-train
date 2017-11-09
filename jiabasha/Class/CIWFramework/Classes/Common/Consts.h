//
//  Consts.h
//  HunBoHuiReqeust_demo
//
//  Created by GarrettGao on 14-10-24.
//  Copyright (c) 2014年 HapN. All rights reserved.
//
//  Git Master 分支

#ifndef HunBoHuiReqeust_demo_Consts_h
#define HunBoHuiReqeust_demo_Consts_h

#define KEY_MODEL      @"kModel"
#define kSelf_View_Tag 135024
#define kCacheCityList @"kCacheCityList"
#define kCityChnage     @"kCityChnageNotification"

// 版本信息
#define kAppID_Weixin           @"wx821a0486164b362a"

/**获取appdelegate*/
#define APP_DELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate
/**设置颜色*/
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(1.0)]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGBFromHexColor(HexValue) \
[UIColor colorWithRed:((float)((HexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((HexValue & 0xFF00) >> 8))/255.0 \
blue:((float)(HexValue & 0xFF))/255.0 alpha:1.0]

/**等到屏幕宽高*/
#define kScreenWidth [UIScreen mainScreen].bounds.size.width //     屏幕宽度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height //   屏幕高度


//当前系统版本是否 >= 某个版本
#define kiOSVersion(v) ([UIDevice currentDevice].systemVersion.floatValue >= (v))

/**iphone比例*/
#define kSeveralfold  kScreenWidth/320.f
#define kSeveralfold6 kScreenWidth/375.f

/**版本号*/
#define APP_VERSION    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define PLUSPLACEHOLDERIMG @"正大"
#define NORMALPLACEHOLDERIMG @"正中"
#define SMALLPALCEHOLDERIMG @"正小"
#define RECTPLACEHOLDERIMG @"长方形"

#define APP_KEY        @"ef8fb154e04c1bdca6e79e022709cfae"
#define APP_ID         @"10013"

//#define REQUEST_HOST   @"https://api.jiehun.com.cn"         // 默认线上接口
#define REQUEST_HOST   @"https://api.jiabasha.com"
//#define REQUEST_HOST   @"http://106.14.41.156:8080/jiabasha/api"

#define RESPONSE_OK       @"ok"

//新浪微博AppKey
#define kAppKey_Weibo           @"3519030991"
#define kRedirectURI_Weibo      @"http://www.jiehun.com.cn/api/weibo/_grant"

//QQ AppKey
#define kAppID_QQ               @"1103569568"


#define kUserAgent @"<<a=yingbasha&p=ybs&m=3>>"

#endif

#ifdef DEBUG

#else

#define NSLog(...) {}

#endif

#ifndef HunBoHuiReqeust_demo_Consts_h
#define HunBoHuiReqeust_demo_Consts_h

#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(1.0)]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define _screenWidth [UIScreen mainScreen].bounds.size.width
#define _screenHeight [UIScreen mainScreen].bounds.size.height
#define USERINFO_DICT [CommonUtil getObjectFromUD:@"UserInfo"]


#define REQUEST_HOST   @"http://106.14.41.156:8080/jiabasha/api"


#define APP_VERSION    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]



#define ERR_NETWORK             @"当前网络不稳定，请重试！"
#define NO_NETWORK              @"没有连接网络"





#endif



