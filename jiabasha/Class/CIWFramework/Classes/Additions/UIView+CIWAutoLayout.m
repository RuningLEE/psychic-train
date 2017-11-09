//
//  UIView+CIWAutoLayout.m
//  CIWFrameWork
//
//  Created by GarrettGao on 15/4/9.
//  Copyright (c) 2015年 MyCompany. All rights reserved.

#import "UIView+CIWAutoLayout.h"
#import "PureLayout.h"

@implementation UIView (CIWAutoLayout)

//////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Top

- (CGFloat)topAuto
{
    return 0;
}

- (void)setTopAuto:(CGFloat)topAuto
{
    [self setNotAutoresizingMaskIntoConstraints];
    [self autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:topAuto];
}

- (NSLayoutConstraint *)setTopAutoOrReturnConstraint:(CGFloat)topAuto
{
    [self setNotAutoresizingMaskIntoConstraints];
    return [self autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:topAuto];
}

#pragma mark - Bottom

- (CGFloat)bottomAuto
{
    return 0;
}

- (void)setBottomAuto:(CGFloat)bottomAuto
{
    [self setNotAutoresizingMaskIntoConstraints];
    [self autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:bottomAuto];
}

- (NSLayoutConstraint *)setBottomAutoOrReturnConstraint:(CGFloat)bottomAuto
{
    [self setNotAutoresizingMaskIntoConstraints];
    return [self autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:bottomAuto];
}


#pragma mark - Left

- (CGFloat)leftAuto{
    return 0;
}

- (void )setLeftAuto:(CGFloat)leftAuto
{
    [self setNotAutoresizingMaskIntoConstraints];
    [self autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:leftAuto];
}

- (NSLayoutConstraint *)setLeftAutoOrReturnConstraint:(CGFloat)leftAuto
{
    [self setNotAutoresizingMaskIntoConstraints];
    return [self autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:leftAuto];
}


#pragma mark - Right 

- (CGFloat)rightAuto
{
    return 0;
}

- (void)setRightAuto:(CGFloat)rightAuto
{
    [self setNotAutoresizingMaskIntoConstraints];
    [self autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:rightAuto];
}

- (NSLayoutConstraint *)setRightAutoOrReturnConstraint:(CGFloat)rightAuto
{
    [self setNotAutoresizingMaskIntoConstraints];
    return [self autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:rightAuto];
}


#pragma mark - Width

- (CGFloat)widthAuto
{
    NSLayoutConstraint *constrain = [self ciw_getConstraintWithDimension:ALDimensionWidth];
    return constrain ? constrain.constant : 0;
}

- (void)setWidthAuto:(CGFloat)widthAuto
{
    [self setNotAutoresizingMaskIntoConstraints];
    NSLayoutConstraint *constraint = [self ciw_getConstraintWithDimension:ALDimensionWidth];
    if(constraint){
        constraint.constant = widthAuto;
    }else{
        [self autoSetDimension:ALDimensionWidth toSize:widthAuto];
    }

}


#pragma mark - Height

- (CGFloat)heightAuto
{
    NSLayoutConstraint *constrain = [self ciw_getConstraintWithDimension:ALDimensionHeight];
    return constrain ? constrain.constant :0;
}

- (void)setHeightAuto:(CGFloat)heightAuto
{
    [self setNotAutoresizingMaskIntoConstraints];
    NSLayoutConstraint *constraint = [self ciw_getConstraintWithDimension:ALDimensionHeight];
    if(constraint){
        constraint.constant = heightAuto;
    }else{
        [self autoSetDimension:ALDimensionHeight toSize:heightAuto];
    }
}

#pragma mark - Size

- (CGSize)sizeAuto
{
    return CGSizeMake(self.widthAuto, self.heightAuto);
}

- (void)setSizeAuto:(CGSize)sizeAuto
{
    BOOL is = NO;
    if([self ciw_getConstraintWithDimension:ALDimensionWidth]){
        self.widthAuto = sizeAuto.width;
        is = YES;
    }
    if([self ciw_getConstraintWithDimension:ALDimensionHeight]){
        self.heightAuto = sizeAuto.height;
        is = YES;
    }
    if(!is){
        [self autoSetDimensionsToSize:sizeAuto];
    }
}



/**
 *获取该view(某个条件)到与某个view之间的玉约束距离
 */
- (NSLayoutConstraint *)getEdgeWithSuperView:(UIView *)superview withEdge:(NSInteger)edge
{
    for (NSLayoutConstraint* constraint in superview.constraints){
        if (constraint.secondItem == self) {
            if(constraint.firstAttribute == edge){
                return constraint;
            }
        }
    }
    return nil;
}


/**
 *获取该view 的某个宽高约束
 */
- (NSLayoutConstraint *)ciw_getConstraintWithDimension:(NSInteger)dimension
{
    return [self ciw_getConstraintWithDimension:dimension withView:self];
}

/**
 *获取某个view满足该条件的某个宽高约束
 */
- (NSLayoutConstraint *)ciw_getConstraintWithDimension:(NSInteger)dimension
                                              withView:(UIView *)view{
    NSArray* constrains = view.constraints;
    for (NSLayoutConstraint* constraint in constrains) {
        if (constraint.firstAttribute == dimension) {
            return constraint;
        }
    }
    return nil;
}




/**
 *禁止Autoresizing和autoLayout之间的自动转换
 */
- (void)setNotAutoresizingMaskIntoConstraints
{
    if(self.translatesAutoresizingMaskIntoConstraints){
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
}


/**AutoLayout语法自定义布局*/
+ (void)ciw_AddConstraintsWithParameter:(NSDictionary *)parameter
                               viewsDic:(NSDictionary *)viewsDic
                            visualFormatArr:(NSArray *)formatArr
                        addConstraintsTo:(UIView *)toView
{
    [UIView ciw_ResolveDic:viewsDic];
    NSMutableArray *contraits = [NSMutableArray array];
    for (NSString *formatStr in formatArr) {
        [contraits addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:formatStr options:0 metrics:parameter views:viewsDic]];
    }
    [toView addConstraints:contraits];
}

+ (void)ciw_ResolveDic:(NSDictionary *)viewsDic
{
    for (NSString *key in [viewsDic allKeys]) {
        if ([key isEqualToString:@"self.view"] || [key isEqualToString:@"self.view"]) {
            continue;
        }
        UIView *view = viewsDic[key];
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////

/**
 Removes all explicit constraints that affect the view.
 WARNING: Apple's constraint solver is not optimized for large-scale constraint removal; you may encounter major performance issues after using this method.
 It is not recommended to use this method to "reset" a view for reuse in a different way with new constraints. Create a new view instead.
 NOTE: This method preserves implicit constraints, such as intrinsic content size constraints, which you usually do not want to remove.
 */
- (void)autoRemoveConstraintsAffectingView
{
    [self autoRemoveConstraintsAffectingViewIncludingImplicitConstraints:NO];
}

/**
 Removes all constraints that affect the view, optionally including implicit constraints.
 WARNING: Apple's constraint solver is not optimized for large-scale constraint removal; you may encounter major performance issues after using this method.
 It is not recommended to use this method to "reset" a view for reuse in a different way with new constraints. Create a new view instead.
 NOTE: Implicit constraints are auto-generated lower priority constraints (such as those that attempt to keep a view at
 its intrinsic content size by hugging its content & resisting compression), and you usually do not want to remove these.
 
 @param shouldRemoveImplicitConstraints Whether implicit constraints should be removed or skipped.
 */
- (void)autoRemoveConstraintsAffectingViewIncludingImplicitConstraints:(BOOL)shouldRemoveImplicitConstraints
{
    NSMutableArray *constraintsToRemove = [NSMutableArray new];
    UIView *startView = self;
    do {
        for (NSLayoutConstraint *constraint in startView.constraints) {
            BOOL isImplicitConstraint = [NSStringFromClass([constraint class]) isEqualToString:@"NSContentSizeLayoutConstraint"];
            if (shouldRemoveImplicitConstraints || !isImplicitConstraint) {
                if (constraint.firstItem == self || constraint.secondItem == self) {
                    [constraintsToRemove addObject:constraint];
                }
            }
        }
        startView = startView.superview;
    } while (startView);
    [UIView autoRemoveConstraints:constraintsToRemove];
}

/**
 Removes the given constraints from the views they have been added to.
 
 @param constraints The constraints to remove.
 */
+ (void)autoRemoveConstraints:(NSArray *)constraints
{
    for (id object in constraints) {
        if ([object isKindOfClass:[NSLayoutConstraint class]]) {
            [self autoRemoveConstraint:((NSLayoutConstraint *)object)];
        } else {
            NSAssert(nil, @"All constraints to remove must be instances of NSLayoutConstraint.");
        }
    }
}

/**
 Removes the given constraint from the view it has been added to.
 
 @param constraint The constraint to remove.
 */
+ (void)autoRemoveConstraint:(NSLayoutConstraint *)constraint
{
    if (constraint.secondItem) {
        UIView *commonSuperview = [constraint.firstItem ciw_commonSuperviewWithView:constraint.secondItem];
        while (commonSuperview) {
            if ([commonSuperview.constraints containsObject:constraint]) {
                [commonSuperview removeConstraint:constraint];
                return;
            }
            commonSuperview = commonSuperview.superview;
        }
    }
    else {
        [constraint.firstItem removeConstraint:constraint];
        return;
    }
    NSAssert(nil, @"Failed to remove constraint: %@", constraint);
}

/**
 Returns the common superview for this view and the given peer view.
 Raises an exception if this view and the peer view do not share a common superview.
 
 @return The common superview for the two views.
 */
- (UIView *)ciw_commonSuperviewWithView:(UIView *)peerView
{
    UIView *commonSuperview = nil;
    UIView *startView = self;
    do {
        if ([peerView isDescendantOfView:startView]) {
            commonSuperview = startView;
        }
        startView = startView.superview;
    } while (startView && !commonSuperview);
    NSAssert(commonSuperview, @"Can't constrain two views that do not share a common superview. Make sure that both views have been added into the same view hierarchy.");
    return commonSuperview;
}

@end
