//
//  UIViewController+CIWAddtions.m
//  HunBaSha
//
//  Created by GarrettGao on 15/10/23.
//  Copyright (c) 2015年 hunbohui. All rights reserved.
//

#import "UIViewController+CIWAddtions.h"

@implementation UIViewController (CIWAddtions)

-(void)setAttributes:(NSDictionary*)dataDic{
    if (![dataDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSEnumerator *keyEnum = [dataDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL sel = [self getSetterSelWithAttibuteName:attributeName];
        if ([self respondsToSelector:sel]) {
            id data = [dataDic objectForKey:attributeName];
            
            if ([data isKindOfClass:[NSNull class]]) {
                data = nil;
            }
            [self performSelectorOnMainThread:sel
                                   withObject:data
                                waitUntilDone:[NSThread isMainThread]];
        }
    }
}
-(SEL)getSetterSelWithAttibuteName:(NSString*)attributeName{
    NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
    NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
    return NSSelectorFromString(setterSelStr);
}

@end
