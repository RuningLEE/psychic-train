//
//  UITextField+CIWAdditions.h
//

#import <UIKit/UIKit.h>

@interface UITextField (CIWAdditions)

+ (UITextField *)textFieldWithFrame:(CGRect)frame
                        borderStyle:(UITextBorderStyle)borderStyle
                          textColor:(UIColor *)textColor
                    backgroundColor:(UIColor *)backgroundColor
                               font:(UIFont *)font
                       keyboardType:(UIKeyboardType)keyboardType
                                tag:(NSInteger)tag;
@end
