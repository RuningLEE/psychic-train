//
//  UIFont+CIWAdditions.m
//

#import "UIFont+CIWAdditions.h"


@implementation UIFont (CIWAdditions)

- (CGFloat)CIWLineHeight {
    return (self.ascender - self.descender) + 1;
}

@end
