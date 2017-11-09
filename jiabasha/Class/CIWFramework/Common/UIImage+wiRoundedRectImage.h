//
//  UIImage+wiRoundedRectImage.h
//  fushi
//
//  Created by Yuhangping on 15/5/26.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (wiRoundedRectImage)

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

@end