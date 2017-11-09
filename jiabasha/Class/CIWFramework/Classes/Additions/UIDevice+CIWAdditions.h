//
//  UIDevice+CIWAdditions.h
//

#import <UIKit/UIKit.h>

@interface UIDevice (CIWAdditions)

+ (BOOL)isHighResolutionDevice;
+ (UIInterfaceOrientation)currentOrientation;
+ (NSString *)getBundleIdentifier;
- (NSString *)getMacAddress;
/**获取iOS设备机型*/
+ (NSString *)getCurrentDeviceModel;

@end
