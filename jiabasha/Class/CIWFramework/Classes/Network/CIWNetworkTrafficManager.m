//
//  CIWNetworkTrafficManager.m
//

#import "CIWNetworkTrafficManager.h"
#import "CIWObjectSingleton.h"

#define SHOULD_LOG_TRAFFIC_DATA YES
@interface CIWNetworkTrafficManager()
- (void)restore;
- (void)inCIWrafficData;
- (double)getMegabytesFromBytes:(int)bytes;
@end
@implementation CIWNetworkTrafficManager

CIWOBJECT_SINGLETON_BOILERPLATE(CIWNetworkTrafficManager, sharedManager)



- (id)init{
    self = [super init];
	if (self) {
		[self restore];
	}
	return self;
}

- (void)dealloc{
    _lastAlertTime = nil;
    _lastResetDate = nil;
}
#pragma mark - private methods
- (void)inCIWrafficData{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    _max3gMegaBytes = [[userinfo objectForKey:CIW_NETWORK_TRAFFIC_MAX_3G] intValue];
    if (!_max3gMegaBytes) {
        _wifiInBytes = 0;
        _wifiOutBytes = 0;
        _3gInBytes = 0;
        _3gOutBytes = 0;
        _resetDayInMonth = 1;
        _max3gMegaBytes = 999;
    }else{
        _wifiInBytes = [[userinfo objectForKey:CIW_NETWORK_TRAFFIC_WIFI_IN] doubleValue];
        _wifiOutBytes = [[userinfo objectForKey:CIW_NETWORK_TRAFFIC_WIFI_OUT] doubleValue];
        _3gInBytes = [[userinfo objectForKey:CIW_NETWORK_TRAFFIC_GPRS_3G_IN] doubleValue];
        _3gOutBytes = [[userinfo objectForKey:CIW_NETWORK_TRAFFIC_GPRS_3G_OUT] doubleValue];
        _resetDayInMonth = [[userinfo objectForKey:CIW_NETWORK_TRAFFIC_RESET_DAY_IN_MONTH] intValue];
        _max3gMegaBytes = [[userinfo objectForKey:CIW_NETWORK_TRAFFIC_MAX_3G] intValue];
    }
    _lastResetDate =(NSDate*)[userinfo objectForKey:CIW_NETWORK_TRAFFIC_LAST_RESET_DATE];
    _isAlert = [userinfo boolForKey:CIW_NETWORK_TRAFFIC_IS_ALERT]; 
    [self checkIsResetDay];
}

- (void)restore{
    _lastAlertTime = nil;
    [self inCIWrafficData];
}

-(void)checkIsResetDay{
    //得到当前的日期
    
    NSDate *date = [NSDate date];
    NSDate *nextResetDate =(NSDate*)[[NSUserDefaults standardUserDefaults] objectForKey:CIW_NETWORK_TRAFFIC_NEXT_RESET_DATE];
    if (!nextResetDate||[nextResetDate timeIntervalSinceNow] < 0) {
        [self resetData];
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitDay fromDate:date];
    NSInteger day = [comps day];
    
    NSInteger nextResetMoth = comps.month;
    NSInteger nextResetYear = comps.year;
    NSInteger nextResetDay = _resetDayInMonth;
    
    if (day>_resetDayInMonth) {
        nextResetMoth +=1;
        if (nextResetMoth>12) {
            nextResetMoth-=12;
            nextResetYear+=1;
        }
    }
    [comps setDay:nextResetDay];
    [comps setMonth:nextResetMoth];
    [comps setYear:nextResetYear];
    
    nextResetDate = [calendar dateFromComponents:comps];
    [[NSUserDefaults standardUserDefaults] setObject:nextResetDate forKey:CIW_NETWORK_TRAFFIC_NEXT_RESET_DATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (double)getMegabytesFromBytes:(int)bytes{
    return (bytes * 1.0/1000)/1000;
}

#pragma mark - public methods
- (void)doSave{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    [userinfo setObject:@(_wifiInBytes) forKey:CIW_NETWORK_TRAFFIC_WIFI_IN];
    [userinfo setObject:@(_wifiOutBytes) forKey:CIW_NETWORK_TRAFFIC_WIFI_OUT];
    [userinfo setObject:@(_3gInBytes) forKey:CIW_NETWORK_TRAFFIC_GPRS_3G_IN];
    [userinfo setObject:@(_3gOutBytes) forKey:CIW_NETWORK_TRAFFIC_GPRS_3G_OUT];
    [userinfo setObject:@(_resetDayInMonth) forKey:CIW_NETWORK_TRAFFIC_RESET_DAY_IN_MONTH];
    [userinfo setObject:@(_max3gMegaBytes) forKey:CIW_NETWORK_TRAFFIC_MAX_3G];
    [userinfo synchronize];
}
// log traffic
- (void)logTrafficIn:(unsigned long long)bytes{
    if (_isUsing3GNetwork) {
        _3gInBytes = _3gInBytes + bytes;
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        [userinfo setObject:@(_3gInBytes) forKey:CIW_NETWORK_TRAFFIC_GPRS_3G_IN];
        [userinfo synchronize];
        if (SHOULD_LOG_TRAFFIC_DATA) {
//            CIWDINFO(@"3g trafic in :%llu bytes", bytes);
        }
    }else{
        _wifiInBytes = _wifiInBytes + bytes;
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        [userinfo setObject:@(_wifiInBytes) forKey:CIW_NETWORK_TRAFFIC_WIFI_IN];
        [userinfo synchronize];
        if (SHOULD_LOG_TRAFFIC_DATA) {
//            CIWDINFO(@"wifi trafic in :%llu bytes", bytes);
        }
    }
    if ([self hasExceedMax3GTraffic]) {
        NSDate *now = [NSDate date];
        BOOL shouldShowAlert = NO;
        if (!_lastAlertTime || [now timeIntervalSinceDate:_lastAlertTime]/100 > CIW_NETWORK_TRAFFIC_MAX_3G_ALERT_INTERVAL) {
            shouldShowAlert = YES;
        }
        if (shouldShowAlert) {
            NSString *alertMsg = [NSString stringWithFormat:@"您目前的GPRS/3g流量(%4.2fM)已超过您所设定的上限(%dM)",[self get3GTraffic],[self getMax3GTraffic] ];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"流量提示" 
                                                             message:alertMsg
                                                            delegate:nil 
                                                   cancelButtonTitle:@"知道了" 
                                                   otherButtonTitles:nil];
            [alert show];
            _lastAlertTime = now;
        }
    }
}
- (void)logTrafficOut:(unsigned long long)bytes{
    if (_isUsing3GNetwork) {
        _3gOutBytes = _3gOutBytes + bytes;
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        [userinfo setObject:@(_3gOutBytes) forKey:CIW_NETWORK_TRAFFIC_GPRS_3G_OUT];
        [userinfo synchronize];
        if (SHOULD_LOG_TRAFFIC_DATA) {
//            CIWDINFO(@"3g trafic out :%llu bytes", bytes);
        }
    }else{
        _wifiOutBytes = _wifiOutBytes + bytes;
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        [userinfo setObject:@(_wifiOutBytes) forKey:CIW_NETWORK_TRAFFIC_WIFI_OUT];
        [userinfo synchronize];
        if (SHOULD_LOG_TRAFFIC_DATA) {
//            CIWDINFO(@"wifi trafic out :%llu bytes", bytes);
        }
    }
}

// set /get reset data date
- (void)setTrafficResetDay:(int)dayInMonth{
    _resetDayInMonth = dayInMonth;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    [userinfo setObject:@(_resetDayInMonth) forKey:CIW_NETWORK_TRAFFIC_RESET_DAY_IN_MONTH];    
    [userinfo synchronize];
    
}
- (int)getTrafficResetDay{
    return _resetDayInMonth;
}

// alert user
- (void)setMax3GTraffic:(int)megabyte{
    _max3gMegaBytes = megabyte;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    [userinfo setObject:@(_max3gMegaBytes) forKey:CIW_NETWORK_TRAFFIC_MAX_3G];
    [userinfo synchronize];
    
}
- (int)getMax3GTraffic{
    return _max3gMegaBytes;
}
- (BOOL)hasExceedMax3GTraffic{
    if (_max3gMegaBytes <= 0 || !_isAlert) {
        return NO;
    }else{
        return ([self get3GTraffic] > _max3gMegaBytes) ;
    }
}

-(void)setAlertStatus:(BOOL)isAlert{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    [userinfo setObject: [NSNumber numberWithInt:isAlert] forKey:CIW_NETWORK_TRAFFIC_IS_ALERT];
    [userinfo synchronize];
    _isAlert = isAlert;
}
-(BOOL)getAlertStatus{
    return _isAlert;
}

// reset
- (void)resetData{
    _wifiInBytes = 0;
    _wifiOutBytes = 0;
    _3gOutBytes = 0;
    _3gInBytes = 0;
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:CIW_NETWORK_TRAFFIC_LAST_RESET_DATE];
    [self doSave];
}

// get traffic data, return megabytes
- (double)get3GTrafficIn{
    return [self getMegabytesFromBytes:_3gInBytes];
}
- (double)get3GTrafficOut{
    return [self getMegabytesFromBytes:_3gOutBytes];
}
- (double)get3GTraffic{
    return [self getMegabytesFromBytes:(_3gInBytes + _3gOutBytes)];
}

- (double)getWifiTrafficIn{
    return [self getMegabytesFromBytes:_wifiInBytes];
}
- (double)getWifiTrafficOut{
    return [self getMegabytesFromBytes:_wifiOutBytes];
}
- (double)getWifiTraffic{
    return [self getMegabytesFromBytes:(_wifiInBytes + _wifiOutBytes)];
}

// for debug
- (void)consoleCurrentTraffic{
//    CIWDINFO(@"==============current network traffic=============\n");
//    CIWDINFO(@"3g in:%fmb", [self get3GTrafficIn]);
//    CIWDINFO(@"3g out:%fmb", [self get3GTrafficOut]);
//    CIWDINFO(@"3g total:%fmb", [self get3GTraffic]);
//    CIWDINFO(@"wifi in:%fmb", [self getWifiTrafficIn]);
//    CIWDINFO(@"wifi out:%fmb", [self getWifiTrafficOut]);
//    CIWDINFO(@"wifi total:%fmb", [self getWifiTraffic]);
//    CIWDINFO(@"==================================================\n");
}
@end
