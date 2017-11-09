//
//  DataEnvironment.m
//
//
//  Copyright 2010 itotem. All rights reserved.
//


#import "DataEnvironment.h"
#import "DataCacheManager.h"
#import "CIWObjectSingleton.h"
#import "CommonUtils.h"

@interface DataEnvironment()
- (void)restore;
- (void)registerMemoryWarningNotification;
@end

#define  kUserInfo @"kUserInfo"


@implementation DataEnvironment
@synthesize city = _city;
@synthesize client = _client;
@synthesize deviceToken = _deviceToken;
@synthesize requestHost = _requestHost;
@synthesize gtClientId  = _gtClientId;
@synthesize isPostToken = _isPostToken;


CIWOBJECT_SINGLETON_BOILERPLATE(DataEnvironment, sharedDataEnvironment)

#pragma mark - lifecycle methods
- (id)init{
    self = [super init];
	if ( self) {
		[self restore];
        [self registerMemoryWarningNotification];
	}
	return self;
}

-(void)clearNetworkData{
    [[DataCacheManager sharedManager] clearAllCache];
}


#pragma mark - public methods
- (void)clearCacheData{
    //clear cache data if needed
}


#define kIsPushNotification @"kIsPushNotification"

#pragma mark - private methods
- (void)restore{
    _urlRequestHost = nil;
    self.userInfo = (UserInfo *)[[DataCacheManager sharedManager] getCachedObjectByKey:kUserInfo];
    
    NSNumber *isPushNotifi = [USER_DEFAULT objectForKey:kIsPushNotification];
    if (!isPushNotifi) {
        isPushNotifi = [NSNumber numberWithBool:YES];
    }
    self.isPushNotification = [isPushNotifi boolValue];
}
- (void)registerMemoryWarningNotification{
#if TARGET_OS_IPHONE
    // Subscribe to app events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearCacheData)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
#ifdef __IPHONE_4_0
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported){
        // When in background, clean memory in order to have less chance to be killed
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCacheData)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
#endif
#endif
}


- (void)setUserInfo:(UserInfo *)userInfo{
    
    if (userInfo) {
        [[DataCacheManager sharedManager] addObject:userInfo forKey:kUserInfo];
    }else{
        _userInfo.isLoginOut = YES;
        [[DataCacheManager sharedManager] removeObjectInCacheByKey:kUserInfo];
        
        [CommonUtils cleanWebCookies];

    }
    _userInfo = userInfo;

}

/**判断是否登录，或者token过期*/
- (BOOL)isLogin{
    if (_userInfo.token.length > 0 && _userInfo.isLoginOut == NO) {
        NSDate *date = [NSDate date];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
        NSString *tokenTime = _userInfo.tokenTime;
        
        if ([timeSp longLongValue] < [tokenTime longLongValue]) {
            return YES;
        }else{
            self.userInfo = nil;
        }
    }
    return NO;
}

#define kCity @"kCity"
- (void)setCity:(City *)city{
    _city = city;
    [[DataCacheManager sharedManager] addObject:city forKey:kCity];
}

- (City *)city{
    return (City *)[[DataCacheManager sharedManager] getCachedObjectByKey:kCity];
}


#define kClient @"kClient"
- (void)setClient:(Client *)client{
    _client = client;
    [[DataCacheManager sharedManager] addObject:client forKey:kClient];
}

- (Client *)client{
    return (Client *)[[DataCacheManager sharedManager] getCachedObjectByKey:kClient];
}




- (void)setIsPushNotification:(BOOL)isPushNotification{
    _isPushNotification = isPushNotification;
    
    [USER_DEFAULT setObject:[NSNumber numberWithBool:isPushNotification] forKey:kIsPushNotification];
    [USER_DEFAULT synchronize];
}


#define kDeviceToken @"kPushToken"

- (void)setDeviceToken:(NSString *)deviceToken{
    _deviceToken = deviceToken;
    
    [USER_DEFAULT setObject:deviceToken forKey:kDeviceToken];
    [USER_DEFAULT synchronize];
}

- (NSString *)deviceToken{
    if (!_deviceToken) {
        _deviceToken = [USER_DEFAULT objectForKey:kDeviceToken];
    }
    return _deviceToken;
}

#define kRequestHost @"kRequestHost_CIW"
- (void)setRequestHost:(NSString *)requestHost
{
    _requestHost = requestHost;
    
    [USER_DEFAULT setObject:requestHost forKey:kRequestHost];
    [USER_DEFAULT synchronize];
}

- (NSString *)requestHost
{
    return REQUEST_HOST;
}


#define kGeTuiClientId @"kGeTuiClientId_CIW"
- (void)setGtClientId:(NSString *)gtClientId
{
    _gtClientId = gtClientId;
    [USER_DEFAULT setObject:gtClientId forKey:kGeTuiClientId];
    [USER_DEFAULT synchronize];
}
- (NSString *)gtClientId
{
    if (!_gtClientId) {
        _gtClientId =  [USER_DEFAULT objectForKey:kGeTuiClientId];
    }
    return _gtClientId;
}



#define kIsPostToken @"kIsPostToken"
- (void)setIsPostToken:(BOOL)isPostToken{
    _isPostToken = isPostToken;
    
    [USER_DEFAULT setBool:isPostToken forKey:kIsPostToken];
    [USER_DEFAULT synchronize];
}

- (BOOL)isPostToken{
    if (!_isPostToken) {
        _isPostToken =  [USER_DEFAULT boolForKey:kIsPostToken];
    }
    return _isPostToken;
}





@end
