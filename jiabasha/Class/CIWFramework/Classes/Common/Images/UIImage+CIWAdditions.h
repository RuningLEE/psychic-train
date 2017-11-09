//
//  UIImage(CIWAdditions).h
//  
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage(ITTAdditions)

- (UIImage *)imageRotatedToCorrectOrientation;
- (UIImage *)imageCroppedWithRect:(CGRect)rect;
- (UIImage *)imageFitInSize: (CGSize) viewsize;
- (UIImage *)imageScaleToFillInSize: (CGSize) viewsize;
/*!
 @author wishpig
 
 @brief 讲图片灰度化
 
 @param sourceImage 源图片
 
 @return 灰度化后的图片
 */
- (UIImage *)grayImage:(UIImage *)sourceImage; //图片变灰
/*!
 @author wishpig
 
 @brief 根据字符串生成二维码的方法
 
 @param qrString 要生成二维码的字符串
 @param size     生成二维码的大小
 
 @return 生成的二维码图片
 */
+ (UIImage *)createQRCodeUIImageFormString:(NSString *)qrString withSize:(CGFloat)size;
/*!
 @author wishpig
 
 @brief 图片颜色转换
 
 @param image 要转换的图片
 @param color 要转换的颜色
 
 @return 转换后的图片
 */
- (UIImage*)imageBlackToTransparent:(UIImage*)image withColor:(UIColor *)color;

@end
