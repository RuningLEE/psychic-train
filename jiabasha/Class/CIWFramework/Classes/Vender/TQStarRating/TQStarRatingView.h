//
//  TQStarRatingView.h
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TQStarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional
-(void)starRatingView:(TQStarRatingView *)view score:(float)score;

@end

@interface TQStarRatingView : UIView

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number;
- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number starSpace:(CGFloat)starSpace;
- (void)changeStarForegroundViewWithPoint:(CGPoint)point;
- (void)changeStarForegroundViewWithScore:(float)score; // 只需传入数字

@property (nonatomic, readonly) int numberOfStar;
@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;
@property (nonatomic) BOOL couldClick;//是否可以点击
@property (nonatomic) BOOL isFill;//是否显示整个星星
@property (nonatomic) CGFloat starSpace;//间隔

@end
