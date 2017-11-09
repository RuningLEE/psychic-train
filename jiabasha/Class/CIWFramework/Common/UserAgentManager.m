//
//  UserAgentManager.m
//  HunBaSha
//
//  Created by GarrettGao on 2017/2/28.
//  Copyright © 2017年 jiabasha. All rights reserved.
//

#import "UserAgentManager.h"
#import "AppDelegate.h"

@implementation UserAgentManager

+ (void)settingUserAgent{
    
    [self settingUserAgentWithClassName:nil];
}

+ (void)settingUserAgentWithClassName:(NSString *)className{
    
    if(![className isKindOfClass:[NSString class]]){
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSArray *viewControllers = [appDelegate getNavigationController].childViewControllers;
        
        id nav = [viewControllers objectAtIndex:0];
        if (viewControllers.count > 1) {
            nav = [viewControllers objectAtIndex:viewControllers.count-2];
        }
//        id nav = [viewControllers objectAtIndex:viewControllers.count-2];
        
        if([nav isKindOfClass:[UITabBarController class]]){
            UITabBarController *tab = nav;
            UIViewController *vc = [tab.viewControllers objectAtIndex:tab.selectedIndex];
            className = NSStringFromClass([vc class]);
        }else{
            className = NSStringFromClass([nav class]);
        }
    }
    [self makeUserAgent:[NSString stringWithFormat:@"<<a=jiabasha&p=jbs&m=1&s=%@>>",className]];
}

+ (void)makeUserAgent:(NSString *)uaString{
    @autoreleasepool {
        UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSString* userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSString *originUserAgent = @"";
        if([userAgent containsString:@"\\<<"]){
            NSArray *arr = [userAgent componentsSeparatedByString:@"\\<<"];
            if(arr.count){
                originUserAgent = [arr firstObject];
            }
        }else{
            originUserAgent = userAgent;
        }
        NSString *ua = [NSString stringWithFormat:@"%@\\%@",
                        originUserAgent,
                        uaString];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua, }];
#if !__has_feature(objc_arc)
        [tempWebView release];
#endif
    }
}
@end
