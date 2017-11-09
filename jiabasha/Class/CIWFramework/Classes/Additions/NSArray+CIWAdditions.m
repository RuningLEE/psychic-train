//
//  NSArray+CIWAdditions.m
//
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSArray+CIWAdditions.h"

@implementation NSArray(CIWAdditions)
-(BOOL)contentString:(NSString *)string{
    for (id object in self) {
        if ([object isKindOfClass:[NSString class]]&&[object isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

-(NSInteger)indexOfString:(NSString *)string{
    for (id object in self) {
        if ([object isKindOfClass:[NSString class]]&&[object isEqualToString:string]) {
            return [self indexOfObject:object];
        }
    }
    return NSNotFound;
}
@end
