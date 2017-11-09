//
//  UserAgentManager.h
//  HunBaSha
//
//  Created by GarrettGao on 2017/2/28.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAgentManager : NSObject

/**设置当前webview的 user-Agent*/
+ (void)settingUserAgent;

/**
 * 设置当前webview的 user-Agent
 * @className 自定义user-Agent<<...>>中的s参数
 */
+ (void)settingUserAgentWithClassName:(NSString *)className;

@end
