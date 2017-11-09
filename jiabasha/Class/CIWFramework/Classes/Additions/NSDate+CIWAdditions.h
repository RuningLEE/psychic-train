//
//  NSDate+CIWAdditions.h
//
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate(CIWAdditions)
+ (NSString *)timeStringWithInterval:(NSTimeInterval) time;
/**转换成标准时间 年月日 时分秒*/
+ (NSString *)standardTimeStringWithInterval:(NSTimeInterval)time;
+ (NSString *)standardCustomTimeStringWithInterval:(NSTimeInterval)time with:(NSString *)FormatterStr;
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate;
+ (NSDate *)relativedDateWithInterval:(NSInteger)interval;

- (NSString *)stringWithSeperator:(NSString *)seperator;
- (NSString *)stringWithFormat:(NSString*)format;
- (NSString *)stringWithSeperator:(NSString *)seperator includeYear:(BOOL)includeYear;
- (NSDate *)relativedDateWithInterval:(NSInteger)interval ;
- (NSString *)weekday;
+ (NSDate *)ZJdateWithString:(NSString *)str formate:(NSString *)formate;
// 比较两个时间戳 计算时间差 返回相差 天小时分钟秒
+ (NSString *)timeCommpleteStringWithNowInterval:(NSTimeInterval)nowTimes andInPastTime:(NSTimeInterval)pastTimes;
+ (NSString *)timeStringWithTimeDifference:(NSTimeInterval)time;
+ (NSString *)ZJtimeStringWithTimeDifference:(NSTimeInterval)time;

@end