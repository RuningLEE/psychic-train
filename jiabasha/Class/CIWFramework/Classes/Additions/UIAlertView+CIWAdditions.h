//
//  UIAlertView+CIWAdditions.h
//

#import <UIKit/UIKit.h>

@interface UIAlertView (CIWAdditions)

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg;
+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel others:(NSString *)others, ...;
@end
