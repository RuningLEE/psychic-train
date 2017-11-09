//
//  UIImage+image_stretch.h
//  zaiuk
//
//  Created by zhangzt on 16/8/17.
//  Copyright © 2016年 hangzhouds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (image_stretch)

+ (instancetype)imageWithOriginalName:(NSString*)imageName;

+ (instancetype)imageWithStretchableName:(NSString*)imageName;

+ (instancetype)unReadimageWithStretchableName:(NSString*)imageName;


@end
