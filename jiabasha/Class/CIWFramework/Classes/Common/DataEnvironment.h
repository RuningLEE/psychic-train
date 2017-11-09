//
//  DataEnvironment.h
//
//  Copyright 2010 itotem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"
#import "Client.h"
//#import "AppInfo.h"
#import "UserInfo.h"
//#import "Version.h"
@interface DataEnvironment : NSObject {
    NSString *_urlRequestHost;
}
@property (nonatomic,retain) NSString *urlRequestHost;

+ (DataEnvironment *)sharedDataEnvironment;

- (void)clearNetworkData;
- (void)clearCacheData;

@property (nonatomic, strong) City *city;
@property (nonatomic, retain) Client *client;
//@property (nonatomic, retain) AppInfo *appInfo;

/**用户信息*/
@property (nonatomic, strong) UserInfo *userInfo;

@property (nonatomic, assign) BOOL isPushNotification;

/**本机的推送token*/
@property (nonatomic, retain) NSString *deviceToken;

/**接口请求域名*/
@property (nonatomic, retain) NSString *requestHost;

/**个推的clientId*/
@property (nonatomic, strong) NSString *gtClientId;

@property (nonatomic, assign) BOOL isPostToken;
/**判断是否登录，或者token过期*/
@property (nonatomic, readonly) BOOL isLogin;
@end
