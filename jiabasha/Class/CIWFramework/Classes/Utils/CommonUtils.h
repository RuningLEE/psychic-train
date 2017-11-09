//
//  CommonUtils.h
//  LingQ
//
//  Created by Rainbow on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface CommonUtils : NSObject

+ (NSString *)convertArrayToString:(NSArray *)array;
+ (NSArray *)convertStringToArray:(NSString *)string;
+ (BOOL)validateEmail:(NSString *)candidate;
+ (BOOL)validateCellPhone:(NSString *)candidate;
//读取 NSUserDefaults
+ (id)getObjectFromUD:(NSString *)key;

//存储 NSUserDefaults
+ (void)saveObjectToUD:(id)value key:(NSString *)key;
+ (void)deleteObjectFromUD:(NSString *)key;

// 判断空字符串
+ (BOOL)isEmpty:(NSString *)string;

+ (long)getDocumentSize:(NSString *)folderName;
+ (NSArray *)getLetters;
+ (NSArray *)getUpperLetters;
//+ (NSString *)getIPAddress;
+ (NSString *)getFreeMemory;
+ (NSString *)getDiskUsed;
+ (NSString *)getStringValue:(id)value;

+ (BOOL)createDirectorysAtPath:(NSString *)path;
+ (NSString*)getDirectoryPathByFilePath:(NSString *)filepath;

// get index by random rate like this NSArray[NSNumber(10.0),NSNumber(30.0),NSNumber(40.0),NSNumber(20.0)]
+(int)getIndexByRandomRates:(NSArray*)rates;

+ (void)addLoginTokenToWebCookiesWithHostName:(NSString *)hostName;
+ (void)cleanWebCookies;

@end
