//
//  CIWCommonFunctions.h
//

#import <UIKit/UIKit.h>
#pragma mark - CGGeometry functions
CGPoint CGRectGetCenter(CGRect rect);
CGFloat distanceBetweenPoints(CGPoint p1,CGPoint p2);
CGFloat angleOfPointFromCenter(CGPoint p,CGPoint center);
BOOL CIWIsModalViewController(UIViewController* viewController);