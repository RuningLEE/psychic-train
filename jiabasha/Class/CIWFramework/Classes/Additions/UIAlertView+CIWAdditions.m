//
//  UIAlertView+CIWAdditions.m
//

#import "UIAlertView+CIWAdditions.h"

@implementation UIAlertView (CIWAdditions)

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg
                                                   delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];	
}

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel others:(NSString *)others, ... {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg
                                                    delegate:delegate cancelButtonTitle:cancel otherButtonTitles:others, nil];
    [alert show];	
}
@end
