//
//  UIView+Category.m
//  HunBaSha
//
//  Created by GarrettGao on 15/11/28.
//  Copyright (c) 2015年 hunbohui. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)



#pragma mark 设置layer的边框线大小，颜色
- (void)layerWithBorderWidth:(CGFloat)width withBorderColor:(UIColor *)color
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

#pragma mark 设置边框为1固定颜色  默认边框和颜色
- (void)layerBorderWidthColorDefault
{
    //    self.layer.borderColor = RGBFromColor(0xCACACA).CGColor;
    self.layer.borderColor = RGBFromHexColor(0xCACACA).CGColor;
    self.layer.borderWidth = .3;
}

#pragma mark 设置layer的圆角
- (void)layerRadius
{
    [self layerWithRadius:self.frame.size.height/2];
}

- (void)layerWithRadius:(CGFloat)radius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

#pragma mark 设置layer成为圆形
- (void)layerRound
{
    CGFloat radius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

#pragma mark 设置边框阴影
- (void)layerWithShadowOffset:(CGSize)offset withColor:(UIColor *)color
{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = YES;
}

/**
 *  向view上添加一条线
 *
 *  @param color    线的颜色
 *  @param position 线的位置
 */
- (CALayer *)createLineLayerWithColor:(UIColor *)color andPosition:(CGPoint)position {

    CALayer *layer = [CALayer layer];
    layer.anchorPoint = CGPointMake(0, 0);
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width, 0.5f);
    layer.backgroundColor = color.CGColor;
    
    return layer;
}

@end
