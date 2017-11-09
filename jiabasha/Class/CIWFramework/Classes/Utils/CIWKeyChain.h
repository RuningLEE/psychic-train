//
//  CIWKeyChain.h
//  HunBaSha
//
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
@interface CIWKeyChain : NSObject

/*
 *  获取应用在设备的唯一标示存入到钥匙串中 防止卸载或重启程序后发生变化*/
+ (NSString *)getAppOnlyIdentifierOnDevice;

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
