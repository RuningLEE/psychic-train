//
//  UIView+Category.h
//  HunBaSha
//
//  Created by GarrettGao on 15/11/28.
//  Copyright (c) 2015年 hunbohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

//设置layer的边框线大小，颜色
- (void)layerWithBorderWidth:(CGFloat)width withBorderColor:(UIColor *)color;

//设置边框为1固定颜色  默认边框和颜色
- (void)layerBorderWidthColorDefault;

//设置layer的圆角
- (void)layerRadius;

- (void)layerWithRadius:(CGFloat)radius;

//设置layer成为圆形
- (void)layerRound;

//设置边框阴影
- (void)layerWithShadowOffset:(CGSize)offset withColor:(UIColor *)color;

/**
 *  向view上添加一条线
 *
 *  @param color    线的颜色
 *  @param position 线的位置
 */
- (CALayer *)createLineLayerWithColor:(UIColor *)color andPosition:(CGPoint)position;


@end
