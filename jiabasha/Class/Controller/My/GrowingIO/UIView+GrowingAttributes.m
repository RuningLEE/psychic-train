//
//  UIView+GrowingAttributes.m
//  jiabasha
//
//  Created by LY123 on 2017/3/22.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "UIView+GrowingAttributes.h"
#import <objc/runtime.h>
static const char kAnaylizeTitle;

@implementation UIView (GrowingAttributes)

-(NSString *)leo_anaylizeTitle{
    return objc_getAssociatedObject(self, &kAnaylizeTitle);
}
-(void)setLeo_anaylizeTitle:(NSString *)leo_anaylizeTitle{
    objc_setAssociatedObject(self, &kAnaylizeTitle,leo_anaylizeTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
