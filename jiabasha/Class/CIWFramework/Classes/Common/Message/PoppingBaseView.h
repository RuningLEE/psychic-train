//
//  PoppingBaseView.h  
//
//  Created by GarrettGao on 13-4-2.
//  Copyright (c) 2013年 HapN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoppingBaseView : UIView

@property (nonatomic, readwrite) UIControl *bgControl;

+ (id)loadFromNib;
- (void)show;
- (void)showWithView:(UIView *)view;
- (void)cancel;
- (void)cancelWithAnimation:(BOOL)isAnimation;

//Subclass
- (void)didShow;
- (void)willCancel:(BOOL)isAutoCancel;
- (void)didCancel;

//Animation
+ (CAKeyframeAnimation*)scaleAnimation:(BOOL)show;

@end
