//
//  NSDate+CIWAdditions.m
//
//  Created by guo hua on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+CIWAdditions.h"

@implementation NSDate(CIWAdditions)
+ (NSString *) timeStringWithInterval:(NSTimeInterval)time{
    
    int distance = [[NSDate date] timeIntervalSince1970] - time;
    NSString *string;
    if (distance < 1){//avoid 0 seconds
        string = @"刚刚";
    }
    else if (distance < 60) {
        string = [NSString stringWithFormat:@"%d秒前", (distance)];
    }
    else if (distance < 3600) {//60 * 60
        distance = distance / 60;
        string = [NSString stringWithFormat:@"%d分钟前", (distance)];
    }  
    else if (distance < 86400) {//60 * 60 * 24
        distance = distance / 3600;
        string = [NSString stringWithFormat:@"%d小时前", (distance)];
    }
    else if (distance < 604800) {//60 * 60 * 24 * 7
        distance = distance / 86400;
        string = [NSString stringWithFormat:@"%d天前", (distance)];
    }
    else if (distance < 2419200) {//60 * 60 * 24 * 7 * 4
        distance = distance / 604800;
        string = [NSString stringWithFormat:@"%d周前", (distance)];
    }
    else {
        NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
        
    }
    
    return string;
}

/**转换成标准时间 年月日 时分秒*/
+ (NSString *)standardTimeStringWithInterval:(NSTimeInterval)time{
   
    return [NSDate standardCustomTimeStringWithInterval:time with:nil];
}
/**转换成标准时间 年月日 时分秒*/
+ (NSString *)standardCustomTimeStringWithInterval:(NSTimeInterval)time with:(NSString *)FormatterStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    if (![FormatterStr isKindOfClass:[NSString class]]||FormatterStr == nil||FormatterStr.length == 0) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else {
        [dateFormatter setDateFormat:FormatterStr];
    }
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
}

- (NSString *)stringWithSeperator:(NSString *)seperator{
	return [self stringWithSeperator:seperator includeYear:YES];
}

// Return the formated string by a given date and seperator.
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSDate *date = [formatter dateFromString:str];
	return date;
}

+ (NSDate *)ZJdateWithString:(NSString *)str formate:(NSString *)formate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *destinationTimeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:destinationTimeZone];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:str];
    return date;
}


- (NSString *)stringWithFormat:(NSString*)format {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	NSString *string = [formatter stringFromDate:self];
	return string;
}

// Return the formated string by a given date and seperator, and specify whether want to include year.
- (NSString *)stringWithSeperator:(NSString *)seperator includeYear:(BOOL)includeYear{
	if( seperator==nil ){
		seperator = @"-";
	}
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	if( includeYear ){
		[formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd",seperator,seperator]];
	}else{
		[formatter setDateFormat:[NSString stringWithFormat:@"MM%@dd",seperator]];
	}
	NSString *dateStr = [formatter stringFromDate:self];
	
	return dateStr;
}

// return the date by given the interval day by today. interval can be positive, negtive or zero. 
+ (NSDate *)relativedDateWithInterval:(NSInteger)interval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger intervalInt = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: intervalInt];
	return localeDate;
}

// return the date by given the interval day by given day. interval can be positive, negtive or zero. 
- (NSDate *)relativedDateWithInterval:(NSInteger)interval{
	NSTimeInterval givenDateSecInterval = [self timeIntervalSinceDate:[NSDate relativedDateWithInterval:0]];
	return [NSDate dateWithTimeIntervalSinceNow:(24*60*60*interval+givenDateSecInterval)];
}

- (NSString *)weekday{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];    
	NSString *weekdayStr = nil;
	[formatter setDateFormat:@"c"];
	NSInteger weekday = [[formatter stringFromDate:self] integerValue];
	if( weekday==1 ){
		weekdayStr = @"星期日";
	}else if( weekday==2 ){
		weekdayStr = @"星期一";
	}else if( weekday==3 ){
		weekdayStr = @"星期二";
	}else if( weekday==4 ){
		weekdayStr = @"星期三";
	}else if( weekday==5 ){
		weekdayStr = @"星期四";
	}else if( weekday==6 ){
		weekdayStr = @"星期五";
	}else if( weekday==7 ){
		weekdayStr = @"星期六";
	}
	return weekdayStr;
}

+ (NSString *)timeStringWithTimeDifference:(NSTimeInterval)time {
    
    int dd = (int)time;
    
    NSString *timeString=@"";
    if (dd<60.f)
    {
        timeString=[NSString stringWithFormat:@"%d秒",dd];
    }
    if (dd>=60.f&&dd<3600.f)
    {
        timeString=[NSString stringWithFormat:@"%d分钟%d秒",dd%3600/60,dd%60];
    }
    if (dd>=3600.f&&dd<86400.f)
    {
        timeString=[NSString stringWithFormat:@"%d小时%d分钟", dd/3600,dd%3600/60];
    }
    if (dd>=86400.f)
    {
        timeString=[NSString stringWithFormat:@"%d天%d小时", dd/86400,dd%86400/3600];
    }
    
    return timeString;
}


+ (NSString *)ZJtimeStringWithTimeDifference:(NSTimeInterval)time {
    
    int dd = (int)time;
    
    NSString *timeString=@"";
//    if (dd<60.f)
//    {
//        timeString=[NSString stringWithFormat:@"%d秒",dd];
//    }
//    if (dd>=60.f&&dd<3600.f)
//    {
//        timeString=[NSString stringWithFormat:@"%d分钟%d秒",dd%3600/60,dd%60];
//    }
//    if (dd>=3600.f&&dd<86400.f)
//    {
//        timeString=[NSString stringWithFormat:@"%d小时%d分钟", dd/3600,dd%3600/60];
//    }
//    if (dd>=86400.f)
//    {
        timeString=[NSString stringWithFormat:@"%@,%@,%@",isNumber(dd%86400/3600),isNumber(dd%3600/60),isNumber(dd%60)];
//    }
    
    return timeString;
}

NSString* isNumber(NSInteger number) {
    if (number < 10) {
        return [NSString stringWithFormat:@"0%ld",(long)number];
    }else {
        return [NSString stringWithFormat:@"%ld",(long)number];
    }
}



+ (NSString *)timeCommpleteStringWithNowInterval:(NSTimeInterval)nowTimes andInPastTime:(NSTimeInterval)pastTimes {
    int dd = nowTimes - pastTimes;
    
    return [self timeStringWithTimeDifference:dd];
}

@end
