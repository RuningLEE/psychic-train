//
//  CommonUtil.m
//  wedding
//
//  Created by duanjycc on 14/11/14.
//  Copyright (c) 2014年 daoshun. All rights reserved.
//
#import <ImageIO/ImageIO.h>
#import "CommonUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#include <sys/types.h>
#include <sys/sysctl.h>

//#import "amrFileCodec.h"                    // 音频转换

static CommonUtil *defaultUtil = nil;

@interface CommonUtil() {
    AppDelegate *appDelegate;
}


@end

@implementation CommonUtil

- (instancetype)init
{
    self = [super init];
    if (self) {
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    
    return self;
}

+ (instancetype)currentUtil
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultUtil = [[CommonUtil alloc] init];
    });
    
    return defaultUtil;
}

+ (void)replaceUserInfoWithUser:(NSDictionary *)dicUser
{
    UserInfo *userinfoModel = [[UserInfo alloc]init];
    userinfoModel.user = [[User alloc]initWithDataDic:[dicUser objectForKey:@"data"]];
    userinfoModel.token = DATA_ENV.userInfo.token;
    userinfoModel.tokenTime = DATA_ENV.userInfo.tokenTime;
    DATA_ENV.userInfo = userinfoModel;
}

+ (NSString *)stringForID:(id)objectid {
    if ([CommonUtil isEmpty:objectid]) {
        return @"";
    }
    
    if ([objectid isKindOfClass:[NSString class]]) {
        return objectid;
    }
    
    if ([objectid isKindOfClass:[NSNumber class]]) {
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        return [numberFormatter stringFromNumber:objectid];
    } else {
        return [NSString stringWithFormat:@"%@", objectid];
    }
}



// 判断空字符串
+ (BOOL)isEmpty:(NSString *)string {
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSString class]] && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isNotEmpty:(NSString *)string {
    return ![CommonUtil isEmpty:string];
}

+ (NSString *)getNumDefaultZero:(NSString *)value {
    
    if ([CommonUtil isEmpty:value]) {
        return @"0";
    } else {
        return [NSString stringWithFormat:@"%@", value];
    }
}

//NSUserDefaults
+ (id)getObjectFromUD:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)saveObjectToUD:(id)value key:(NSString *)key {
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutaDic = [value mutableCopy];
        NSArray *allkeys = mutaDic.allKeys;
        for (int i=0; i<[allkeys count]; i++) {
            NSString *key = [allkeys objectAtIndex:i];
            
            NSString *value = [mutaDic objectForKey:key];
            if ([CommonUtil isEmpty:value]) {
                [mutaDic setObject:@"" forKey:key];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:mutaDic forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteObjectFromUD:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)showAlertView:(NSString *)message {
    [self showAlertView:message delegate:nil];
}

+ (void)showAlertView:(NSString *)message delegate:(id)delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil];
    [alert show];
}

//MD5加密
+ (NSString *)md5:(NSString *)password {
    const char *original_str = [password UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

//手机号码验证
+ (BOOL)checkPhonenum:(NSString *)phone {

    //手机号以1开头，11位数字
    NSString *phoneRegex = @"^[1]\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

//获得设备型号
+ (NSString *)getCurrentDeviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    //NSString *platform = [NSString stringWithUTF8String:machine];二者等效
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

/**
 * 判断是否登录
 */
- (BOOL)isLogin {
    return [self isLogin:YES];
}

- (BOOL)isLogin:(BOOL)needLogin {
    BOOL isLogin = NO;
    if (![CommonUtil isEmpty:appDelegate.userid]) {
        isLogin = YES;
    } else {
        //需要进行登录
        if (needLogin) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"needlogin" object:nil];
        }
    }
    
    return isLogin;
}

- (NSString *)getLoginUserid {
    return appDelegate.userid;
}


+ (UIImage *)fixOrientation:(UIImage *)srcImg {
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return [CommonUtil scaleImage:img minLength:1000];
}

+ (UIImage *)scaleImage:(UIImage *)image minLength:(float)length
{
    if (image.size.width <= length || image.size.height <= length) {
        return image;
    }
    
    CGFloat scaleSize = MAX(length/image.size.width, length/image.size.height);
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/****************** 关于时间方法 ******************/

// Date 转换 NSString (默认格式：自定义)
+ (NSString *)getStringForDate:(NSDate *)date format:(NSString *)format {
    if (format == nil) format = @"yyyy-MM-dd HH:mm:ss";
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    
    return currentDateStr;
}

// NSString 转换 Date (默认格式：自定义)
+ (NSDate *)getDateForString:(NSString *)string format:(NSString *)format; {
    if (format == nil) format = @"yyyy-MM-dd HH:mm:ss";
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter dateFromString:string];
}

// NSString 转换 Date (默认格式：自定义)
+ (NSDate *)getDateForString1:(NSString *)string format:(NSString *)format; {
    if (format == nil) format = @"yyyy-MM-dd";
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter dateFromString:string];
}


// 记录debug数据(log)
+ (void)writeDebugLogName:(NSString *)name data:(NSString *)data
{
    // 创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 查找文件（设置目录）
    NSArray *directoryPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 传递 0 代表是找在Documents 目录下的文件。
    NSString *documentDirectory = [directoryPaths  objectAtIndex:0];
    // DBNAME 是要查找的文件名字，文件全名
    NSString *filePath = [documentDirectory  stringByAppendingPathComponent:@"debug.text"];
    NSLog(@"filePath  %@",filePath);
    // 用这个方法来判断当前的文件是否存在，如果不存在，就创建一个文件
    if ( ![fileManager fileExistsAtPath:filePath])
    {
        [fileManager createFileAtPath:filePath  contents:nil attributes:nil];
    }
    
    // 获取当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    
    // 获取数据
    //    NSString* fileName = [documentDirectory stringByAppendingPathComponent:@"debug.text"];
    NSString *str = [NSString stringWithFormat:@"%@"@"  [%@]  "@"%@"@"\r\n",time,name,data];
    NSData *fileData = [str dataUsingEncoding:NSUTF8StringEncoding];
    //    [fileData writeToFile:fileName atomically:YES];
    
    // 追加写入数据
    NSFileHandle  *outFile;
    outFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if(outFile == nil)
    {
        NSLog(@"Open of file for writing failed");
    }
    
    //找到并定位到outFile的末尾位置(在此后追加文件)
    [outFile seekToEndOfFile];
    [outFile writeData:fileData];
    
    //关闭读写文件
    [outFile closeFile];
    
//    // 读取文件数据：
//    // 用 NSData 来读取文件内容
//    NSData *fileData1 = [NSData dataWithContentsOfFile:filePath];
//    
//    NSString *uri = @"/UserServlet";
//    NSDictionary *params = [RequestHelper getParamsWithURI:uri Parameters:nil RequestMethod:Request_POST];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    //    AFHTTPRequestOperation *operation =
//    [manager POST:[RequestHelper getFullUrl:uri] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:fileData1
//                                    name:@"debug.txt"
//                                fileName:@"debug.txt"
//                                mimeType:@"txt"];
//    }success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         NSLog(@"日志上传成功");
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"Error: %@", error);
////         [self makeToast:@"日志上传失败，请重试"];
//     }];
}

// 根据文字，字号及固定宽(固定高)来计算高(宽) 需要计算什么，什么传值“0”
+ (CGSize)sizeWithString:(NSString *)text
                fontSize:(CGFloat)fontsize
               sizewidth:(CGFloat)width
              sizeheight:(CGFloat)height
{
    if ([self isEmpty:text]) {
        return CGSizeZero;
    }
    // 用何种字体显示
    UIFont *font = [UIFont systemFontOfSize:fontsize];
    CGSize expectedLabelSize = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSAttributedString *attributeText=[[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle}];
        CGSize labelsize = [attributeText boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        expectedLabelSize = CGSizeMake(ceilf(labelsize.width),ceilf(labelsize.height));
    } else {
        expectedLabelSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, height) lineBreakMode:NSLineBreakByCharWrapping];
    }
    // 计算出显示完内容的最小尺寸
    return expectedLabelSize;
}

// 窗口弹出动画
+ (void)shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.75;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [aView.layer addAnimation:animation forKey:nil];
}

//裁切图片为六边形
+ (UIImage *)cutImageHex:(UIImage *)image{
    if (image == nil) return nil;
    
    //从Bundle中读取图片
    UIImage *srcImg = image;
    CGFloat width = srcImg.size.width;
    CGFloat height = srcImg.size.height;
    
    //开始绘制图片
    UIGraphicsBeginImageContext(srcImg.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSetLineCap(ctx,kCGLineCapRound);//设置线条两端的样式为圆角
    
    CGContextMoveToPoint(ctx, width/2 - 16, 3);//顶点
    CGContextAddLineToPoint(ctx, 10, height/5*1.5 - 10);//左1
    
    /*
     CGContextAddQuadCurveToPoint ( CGContextRef c, CGFloat cpx,//控制点 x坐标
     CGFloat cpy,//控制点 y坐标
     CGFloat x,//直线的终点 x坐标
     CGFloat y//直线的终点 y坐标
     );
     */
    CGContextAddQuadCurveToPoint(ctx, -4, height/5*1.5, 0, height/5*2.5);//左1
    CGContextAddQuadCurveToPoint(ctx, -4, height/5*3.5, 10, height/5*3.5 + 10);//左2
    CGContextAddLineToPoint(ctx, width/2 - 16, height - 3);//底部
    CGContextAddQuadCurveToPoint(ctx, width/2, height, width/2 + 10, height - 3);//底部
    CGContextAddLineToPoint(ctx, width - 10, height/5*3.5 + 10);//右2
    CGContextAddQuadCurveToPoint(ctx, width + 4, height/5*3.5, width, height/5*2.5);//右2
    CGContextAddQuadCurveToPoint(ctx, width + 4, height/5*1.5, width - 10, height/5*1.5 - 10);//右1
    CGContextAddLineToPoint(ctx, width/2 + 16, 3);
    CGContextAddQuadCurveToPoint(ctx, width/2, 0, width/2 - 16, 3);//顶部
    CGContextClosePath(ctx);
    
    //加入矩形边框并调用CGContextEOClip函数
    CGContextClip(ctx);
    
    //坐标系转换
    //因为CGContextDrawImage会使用Quartz内的以左下角为(0,0)的坐标系
    CGContextTranslateCTM(ctx, 0, height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), [srcImg CGImage]);
    
    //结束绘画
    UIImage *destImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    

    return destImg;
}

//裁切图片为六边形
+ (UIImageView *)cutImageHex2:(UIImageView *)imageView{
    if (imageView == nil) return nil;
    
    CGFloat lineWidth    = 5.0;
    UIBezierPath *path   = [CommonUtil roundedPolygonPathWithRect:imageView.bounds
                                                        lineWidth:lineWidth
                                                            sides:6
                                                     cornerRadius:5];
    
    CAShapeLayer *mask   = [CAShapeLayer layer];
    mask.path            = path.CGPath;
    mask.lineWidth       = lineWidth;
    mask.strokeColor     = [UIColor clearColor].CGColor;
    mask.fillColor       = [UIColor whiteColor].CGColor;
    imageView.layer.mask = mask;
    
    CAShapeLayer *border = [CAShapeLayer layer];
    border.path          = path.CGPath;
    border.lineWidth     = lineWidth;
    border.strokeColor   = [UIColor blackColor].CGColor;
    border.fillColor     = [UIColor clearColor].CGColor;
    [imageView.layer addSublayer:border];
    
    
    return imageView;
}

/** Create UIBezierPath for regular polygon with rounded corners
 *
 * @param square        The CGRect of the square in which the path should be created.
 * @param lineWidth     The width of the stroke around the polygon. The polygon will be inset such that the stroke stays within the above square.
 * @param sides         How many sides to the polygon (e.g. 6=hexagon; 8=octagon, etc.).
 * @param cornerRadius  The radius to be applied when rounding the corners.
 *
 * @return              UIBezierPath of the resulting rounded polygon path.
 */

+ (UIBezierPath *)roundedPolygonPathWithRect:(CGRect)square
                                   lineWidth:(CGFloat)lineWidth
                                       sides:(NSInteger)sides
                                cornerRadius:(CGFloat)cornerRadius
{
    UIBezierPath *path  = [UIBezierPath bezierPath];
    
    CGFloat theta       = 2.0 * M_PI / sides;                           // how much to turn at every corner
    CGFloat offset      = cornerRadius * tanf(theta / 2.0);             // offset from which to start rounding corners
    CGFloat squareWidth = MIN(square.size.width, square.size.height);   // width of the square
    
    // calculate the length of the sides of the polygon
    
    CGFloat length      = squareWidth - lineWidth;
    if (sides % 4 != 0) {                                               // if not dealing with polygon which will be square with all sides ...
        length = length * cosf(theta / 2.0) + offset/2.0;               // ... offset it inside a circle inside the square
    }
    CGFloat sideLength = length * tanf(theta / 2.0);
    
    // start drawing at `point` in lower right corner
    
    CGPoint point = CGPointMake(squareWidth / 2.0 + sideLength / 2.0 - offset, squareWidth - (squareWidth - length) / 2.0);
    CGFloat angle = M_PI;
    [path moveToPoint:point];
    
    // draw the sides and rounded corners of the polygon
    
    for (NSInteger side = 0; side < sides; side++) {
        point = CGPointMake(point.x + (sideLength - offset * 2.0) * cosf(angle), point.y + (sideLength - offset * 2.0) * sinf(angle));
        [path addLineToPoint:point];
        
        CGPoint center = CGPointMake(point.x + cornerRadius * cosf(angle + M_PI_2), point.y + cornerRadius * sinf(angle + M_PI_2));
        [path addArcWithCenter:center radius:cornerRadius startAngle:angle - M_PI_2 endAngle:angle + theta - M_PI_2 clockwise:YES];
        
        point = path.currentPoint; // we don't have to calculate where the arc ended ... UIBezierPath did that for us
        angle += theta;
    }
    
    [path closePath];
    
    return path;
}

+ (void)addShadow:(UIView *)shadowView color:(UIColor *)color radius:(CGFloat)radius opacity:(CGFloat)opacity cornerRadius:(CGFloat)cornerRadius{
    if (!shadowView) {
        return;
    }
    
    shadowView.layer.cornerRadius = cornerRadius;
    shadowView.layer.shadowColor = color.CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    shadowView.layer.shadowRadius = radius;
    shadowView.layer.shadowOpacity = opacity;
    
}

/****************** 关于音频格式转换 ******************/
/*
 IOS录音的格式是PCM或Wave的，Android录音格式是Amr，为了同步音频文件格式
 注：需要“共同文件》第三方包》AudioConverter”添加到项目中
 */

///* 将Amr格式转换成Wave */
//+ (NSData *)encodeAmrToWave:(NSData *)data {
//    if (!data) return data;
//    return DecodeAMRToWAVE(data);
//}
//
///* 将Wave格式转换成Amr */
//+ (NSData *)encodeWaveToAmr:(NSData *)data {
//    if (!data) return data;
//    return EncodeWAVEToAMR(data,1,16);
//}

/**************** 追加_关于当期项目中重复使用快捷方法 **********************/

// 音频时间长度计算
+ (NSString *)doGetRecordTime:(NSDate *)startDate recordEndDate:(NSDate *)endDate {
    
    NSString *timeString = @"";
    NSTimeInterval late=[startDate timeIntervalSince1970]*1;
    NSTimeInterval now=[endDate timeIntervalSince1970]*1;
    NSTimeInterval cha=now-late;
    
    timeString = [NSString stringWithFormat:@"%f", cha];
    timeString = [timeString substringToIndex:timeString.length-7];
    
    return timeString;
}

// 从URL字符串中获取文件名
+ (NSString *)getFilenameFromUrl:(NSString *)url {
    NSString *filename = nil;
    if ([CommonUtil isEmpty:url]) {
        return nil;
    }
    
    NSArray *aArray = [url componentsSeparatedByString:@"/"];
    filename = [aArray objectAtIndex:([aArray count] - 1)];
    aArray = [filename componentsSeparatedByString:@"?"];
    filename = [aArray objectAtIndex:0];
    
    NSString *v = @"";
    if ([aArray count] > 1) {
        v= [aArray objectAtIndex:1];
        aArray = [v componentsSeparatedByString:@"="];
        if ([aArray count] > 1) {
            v = [aArray objectAtIndex:1];
        }
        if (v == nil) v= @"";
    }
    
    return [NSString stringWithFormat:@"%@%@", v, filename];
}

// 设置红点
+ (UIView *)redView:(CGFloat)width andNumber:(NSInteger)number andView:(UIView *)viewNum
{
    // 移除label
    for (id objc in viewNum.subviews) {
        if ([objc isKindOfClass:[UILabel class]]) {
            [objc removeFromSuperview];
        }
    }
    viewNum.layer.cornerRadius = width/2;
    viewNum.layer.masksToBounds = YES;
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.font = [UIFont systemFontOfSize:width/2];
    if (number > 99) {
         numberLabel.text = @"99+";
    }else{
        if (number <= 0) {
            number = 0;
            viewNum.hidden = YES;
        }else{
            viewNum.hidden = NO;
             numberLabel.text = [NSString stringWithFormat:@"%ld", (long)number];
        }
    }

    [viewNum addSubview:numberLabel];
    return viewNum;
}


+ (UIImageView *)startLoading:(UIImageView *)imageGif{
    NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"bg_loading1"],
                         [UIImage imageNamed:@"bg_loading2"],
                         [UIImage imageNamed:@"bg_loading3"],
                         [UIImage imageNamed:@"bg_loading4"],
                         [UIImage imageNamed:@"bg_loading5"],
                         [UIImage imageNamed:@"bg_loading6"],
                         [UIImage imageNamed:@"bg_loading7"],
                         [UIImage imageNamed:@"bg_loading8"],
                         [UIImage imageNamed:@"bg_loading9"],nil];
    imageGif.animationImages = gifArray; //动画图片数组
    imageGif.animationDuration = 1; //执行一次完整动画所需的时长
    imageGif.animationRepeatCount = MAXFLOAT;  //动画重复次数
    [imageGif startAnimating];
    return imageGif;
    
}



+ (CGSize)getImageSizeWithURL:(NSURL *)url
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0.0f, height = 0.0f;
    
    if (imageSource)
    {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
        
        if (imageProperties != NULL)
        {
            CFNumberRef widthNum  = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            if (widthNum != NULL) {
                CFNumberGetValue(widthNum, kCFNumberCGFloatType, &width);
                //width = (float)widthNum;
            }
            
            CFNumberRef heightNum = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNum != NULL) {
                CFNumberGetValue(heightNum, kCFNumberCGFloatType, &height);
            }
            
            CFRelease(imageProperties);
        }
        CFRelease(imageSource);
        NSLog(@"Image dimensions: %.0f x %.0f px", width, height);
    }
    return CGSizeMake(width, height);
}

// 注销登录
+ (void)logOff{
   // AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
   // app.userid = nil;
    [CommonUtil saveObjectToUD:nil key:@"UserInfo"];            // 清除用户信息
    [CommonUtil saveObjectToUD:nil key:@"avatarurl"];           // 清除用户头像链接
    [CommonUtil saveObjectToUD:nil key:@"sex"];                 // 清除用户性别
    [CommonUtil saveObjectToUD:nil key:@"nickname"];            // 清除用户昵称
    [CommonUtil saveObjectToUD:nil key:@"balance"];             // 清除用户余额
    
    if ([[CommonUtil currentUtil] isLogin]) {
    
    }
    
}

/**
 *获取URL中的uri参数
 */
+ (NSDictionary *)GetUriParametersWithUrl:(NSString *)url
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if([url rangeOfString:@"?"].location !=NSNotFound){
        NSString *parametersString = @"";
        NSRange range = [url rangeOfString:@"?"];//匹配得到的下标
        //截取url中第一个?之后的字符串
        parametersString = [url substringFromIndex:(range.location<url.length)?range.location + 1:range.location];
        NSArray *allParameterArr = [parametersString componentsSeparatedByString:@"&"];
        
        for(NSString *keyAndValve in allParameterArr){
            
            NSArray *aKeyAndValueArr = [keyAndValve componentsSeparatedByString:@"="];
            if(aKeyAndValueArr.count == 2){
                [parameters setObject:aKeyAndValueArr[1] forKey:aKeyAndValueArr[0]];
            }
        }
    }
    return parameters;
}

// 唤醒登录
+ (void)needLoginView{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"goLoginView" object:nil];
}

//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}


@end
