//
//  CIWXibViewUtils.m
//

#import "CIWXibViewUtils.h"

@implementation CIWXibViewUtils

+ (id)loadViewFromXibNamed:(NSString*)xibName withFileOwner:(id)fileOwner{
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(xibName)];
    NSArray *array = [bundle loadNibNamed:xibName owner:fileOwner options:nil];
    if (array && [array count]) {
        return array[0];
    }else {
        return nil;
    }
}

+ (id)loadViewFromXibNamed:(NSString*)xibName {
    return [CIWXibViewUtils loadViewFromXibNamed:xibName withFileOwner:self];
}

+ (id)loadViewFromXibNamed:(NSString*)xibName andIndex:(NSInteger)index {
    return [CIWXibViewUtils loadViewFromXibNamed:xibName withFileOwner:self withIndex:index];
}

+ (id)loadViewFromXibNamed:(NSString*)xibName withFileOwner:(id)fileOwner withIndex:(NSInteger)index{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:xibName owner:fileOwner options:nil];
    if (array && [array count]&&index >= 0&&index < array.count) {
        return array[index];
    }else {
        return nil;
    }
}



@end
