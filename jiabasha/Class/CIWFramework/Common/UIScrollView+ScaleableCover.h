//
//  UIScrollView+ScaleableCover.h
//  TableViewScaleableHeader
//
//  Created by jhon on 16/4/29.
//  Copyright © 2016年 yutao. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat MaxHeight = 246;

@interface ScaleableCover : UIImageView

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@interface UIScrollView (ScaleableCover)

@property (nonatomic, weak) ScaleableCover *scaleableCover;

- (void)addScaleableCoverWithImage:(UIImage *)image;
- (void)removeScaleableCover;

@end
