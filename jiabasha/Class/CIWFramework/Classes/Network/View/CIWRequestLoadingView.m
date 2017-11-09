//
//  CIWRequestLoadingView.m
//  MuYing
//
//  Created by GarrettGao on 2016/11/26.
//  Copyright © 2016年 HunBoHui. All rights reserved.
//

#import "CIWRequestLoadingView.h"

@implementation CIWRequestLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, RGB(224, 32, 32).CGColor);
    CGFloat startAngle = -M_PI/3;
    CGFloat step = 11*M_PI/6 * self.progress;
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, self.bounds.size.width/2-3, startAngle, startAngle+step, 0);
    CGContextStrokePath(context);
}

@end
