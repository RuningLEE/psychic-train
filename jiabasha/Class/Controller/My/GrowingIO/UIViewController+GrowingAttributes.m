//
//  UIViewController+GrowingAttributes.m
//  jiabasha
//
//  Created by LY123 on 2017/3/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "UIViewController+GrowingAttributes.h"
#import <objc/runtime.h>
static const void *IndieBandNameKey = &IndieBandNameKey;
@implementation UIViewController (GrowingAttributes)
@dynamic growingAttributesPageName;
- (NSString *)growingAttributesPageName {
    return objc_getAssociatedObject(self, IndieBandNameKey);
}
@end
