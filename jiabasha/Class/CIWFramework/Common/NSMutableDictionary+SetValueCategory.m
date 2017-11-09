//
//  NSMutableDictionary+SetValueCategory.m
//  jiabasha
//
//  Created by zhangzt on 2017/1/12.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "NSMutableDictionary+SetValueCategory.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (SetValueCategory)

+ (void)load{
    Method method_fir = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setValue:forKey:));
    Method method_sec = class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(JohnSetValue:ForKey:));
    method_exchangeImplementations(method_fir, method_sec);
}

- (void)JohnSetValue:(id)Value ForKey:(NSString*)Key{
    if (Value == nil) {
//        KKLog(@"value is null");
        return;
    }else{
        [self JohnSetValue:Value ForKey:Key];
    }
}

@end
