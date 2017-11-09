//
//  UIImage+image_stretch.m
//  zaiuk
//
//  Created by zhangzt on 16/8/17.
//  Copyright © 2016年 hangzhouds. All rights reserved.
//

#import "UIImage+image_stretch.h"

@implementation UIImage (image_stretch)

+ (instancetype)imageWithOriginalName:(NSString*)imageName{

    UIImage* image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
}

+ (instancetype)imageWithStretchableName:(NSString*)imageName{

    UIImage* image = [UIImage imageNamed:imageName];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.9];
}

+ (instancetype)unReadimageWithStretchableName:(NSString*)imageName{
    
    UIImage* image = [UIImage imageNamed:imageName];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width*0.65 topCapHeight:image.size.height*0.5];
}


@end
