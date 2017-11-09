//
//  NSLocale+CIWAdditions.m
//
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSLocale+CIWAdditions.h"

@implementation NSLocale(CIWAdditions)
+ (NSString *)getCountryCode
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    return [currentLocale objectForKey:NSLocaleCountryCode];
}

+ (NSString *)getLanguageCode
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    return [currentLocale objectForKey:NSLocaleLanguageCode];
}
@end
