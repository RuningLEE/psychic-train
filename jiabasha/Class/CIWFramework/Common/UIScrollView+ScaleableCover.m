//
//  UIScrollView+ScaleableCover.m
//  TableViewScaleableHeader
//
//  Created by john on 16/4/29.
//  Copyright © 2016年 yutao. All rights reserved.
//

#import "UIScrollView+ScaleableCover.h"
#import <objc/runtime.h>

static NSString * const kContentOffset = @"contentOffset";
static NSString * const kScaleableCover = @"scaleableCover";

@implementation ScaleableCover

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setScrollView:(UIScrollView *)scrollView{
    [_scrollView removeObserver:scrollView forKeyPath:kContentOffset];
    _scrollView = scrollView;
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeFromSuperview{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [super removeFromSuperview];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.scrollView.contentOffset.y < 0) {
        CGFloat offset = -self.scrollView.contentOffset.y;
        
        self.frame = CGRectMake(-offset, -offset, _scrollView.bounds.size.width + offset * 2, MaxHeight + offset);
    }else{
        self.frame = CGRectMake(0, 0, _scrollView.bounds.size.width, MaxHeight);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    [self setNeedsLayout];
}

@end



@implementation UIScrollView (ScaleableCover)

- (void)setScaleableCover:(ScaleableCover *)scaleableCover{
    [self willChangeValueForKey:kScaleableCover];
    objc_setAssociatedObject(self, @selector(scaleableCover), scaleableCover, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kScaleableCover];
}

- (ScaleableCover *)scaleableCover{
    return objc_getAssociatedObject(self, &kScaleableCover);
}

- (void)addScaleableCoverWithImage:(UIImage *)image{
    ScaleableCover *cover = [[ScaleableCover alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, MaxHeight)];
    
    cover.backgroundColor = [UIColor clearColor];
    cover.image = image;
    cover.scrollView = self;
    
    [self addSubview:cover];
    [self sendSubviewToBack:cover];
    
    self.scaleableCover = cover;
}

- (void)removeScaleableCover{
    [self.scaleableCover removeFromSuperview];
    self.scaleableCover = nil;
}

@end
