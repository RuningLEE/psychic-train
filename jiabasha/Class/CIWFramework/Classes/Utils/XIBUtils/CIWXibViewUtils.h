//
//  CIWXibViewUtils.h
//

#import <UIKit/UIKit.h>

@interface CIWXibViewUtils : NSObject

+ (id)loadViewFromXibNamed:(NSString*)xibName withFileOwner:(id)fileOwner;
+ (id)loadViewFromXibNamed:(NSString*)xibName andIndex:(NSInteger)index;
//  the view must not have any connecting to the file owner
+ (id)loadViewFromXibNamed:(NSString*)xibName;
@end
