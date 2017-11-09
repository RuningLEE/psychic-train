//
//  UIView+CIWAutoLayout.h
//  CIWFrameWork
//
//  Created by GarrettGao on 15/4/9.
//  Copyright (c) 2015年 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>




#pragma mark - UIView+AutoLayout

/**
 A category on UIView that provides a simple yet powerful interface for creating Auto Layout constraints.
 */
@interface UIView (CIWAutoLayout)


/**
 *使用autolayout设置view到父视图的做边距
 */
@property (nonatomic) CGFloat leftAuto;


@property (nonatomic) CGFloat topAuto;


@property (nonatomic) CGFloat rightAuto;


@property (nonatomic) CGFloat bottomAuto;


@property (nonatomic) CGFloat widthAuto;


@property (nonatomic) CGFloat heightAuto;


@property (nonatomic) CGSize sizeAuto;


/**
 * 设置某个view到superView的 上，下，左，右 约束，且返回 NSLayoutConstraint
 */
- (NSLayoutConstraint *)setTopAutoOrReturnConstraint:(CGFloat)topAuto;
- (NSLayoutConstraint *)setBottomAutoOrReturnConstraint:(CGFloat)bottomAuto;
- (NSLayoutConstraint *)setLeftAutoOrReturnConstraint:(CGFloat)leftAuto;
- (NSLayoutConstraint *)setRightAutoOrReturnConstraint:(CGFloat)rightAuto;



/**
 *获取该view(某个条件)到与某个view之间的约束距离
 */
- (NSLayoutConstraint *)getEdgeWithSuperView:(UIView *)superview withEdge:(NSInteger)edge;

/**
 *获取该view 的某个宽高约束
 */
- (NSLayoutConstraint *)ciw_getConstraintWithDimension:(NSInteger)dimension;

/**禁止Autoresizing和autoLayout之间的自动转换*/
- (void)setNotAutoresizingMaskIntoConstraints;

/**
 *获取某个view满足该条件的某个宽高约束
 */
- (NSLayoutConstraint *)ciw_getConstraintWithDimension:(NSInteger)dimension
                                              withView:(UIView *)view;


/**
 *  AutoLayout语法自定义布局
 *  @parameter: 设置参数，可以为空
 *  @views:     需要参数添加约束的view(数组)
 *  @formatArr: 约束条件数组
 *  @toView:    将约束添加到这个view
 */
+ (void)ciw_AddConstraintsWithParameter:(NSDictionary *)parameter
                               viewsDic:(NSDictionary *)viewsDic
                        visualFormatArr:(NSArray *)formatArr
                       addConstraintsTo:(UIView *)toView;

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

- (void)autoRemoveConstraintsAffectingView;


@end
