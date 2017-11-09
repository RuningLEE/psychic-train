//
//  CommonUtil.h
//  wedding
//
//  Created by duanjycc on 14/11/14.
//  Copyright (c) 2014年 daoshun. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject

/**
 更新UserInfo

 @param dicUser data字典
 */
+ (void)replaceUserInfoWithUser:(NSDictionary *)dicUser;
/**
 *  共同处理类单例实例化
 *
 *  @return 共同处理类单例
 */
+ (instancetype)currentUtil;

// 判断空字符串
+ (BOOL)isEmpty:(NSString *)string;
+ (BOOL)isNotEmpty:(NSString *)string;
+ (NSString *)stringForID:(id)objectid;

+ (NSString *)getNumDefaultZero:(NSString *)value;

//读取 NSUserDefaults
+ (id)getObjectFromUD:(NSString *)key;

//存储 NSUserDefaults
+ (void)saveObjectToUD:(id)value key:(NSString *)key;
+ (void)deleteObjectFromUD:(NSString *)key;

//MD5加密
+ (NSString *)md5:(NSString *)password;

//手机号码验证
+ (BOOL)checkPhonenum:(NSString *)phone;

//获得设备型号
+ (NSString *)getCurrentDeviceModel;

//判断是否登录
- (BOOL)isLogin;
- (BOOL)isLogin:(BOOL)needLogin;
- (NSString *)getLoginUserid;

//图片方向处理
+ (UIImage *)fixOrientation:(UIImage *)srcImg;

// 图片尺寸缩小
+ (UIImage *)scaleImage:(UIImage *)image minLength:(float)length;

/****************** 关于时间方法 <S> ******************/
// Date 转换 NSString (默认格式：自定义)
+ (NSString *)getStringForDate:(NSDate *)date format:(NSString *)format;

// NSString 转换 Date (默认格式：自定义)
+ (NSDate *)getDateForString:(NSString *)string format:(NSString *)format;

+ (NSDate *)getDateForString1:(NSString *)string format:(NSString *)format;


// 记录debug数据(log)
+ (void)writeDebugLogName:(NSString *)name data:(NSString *)data;


// 根据文字，字号及固定宽(固定高)来计算高(宽)
+ (CGSize)sizeWithString:(NSString *)text
                fontSize:(CGFloat)fontsize
               sizewidth:(CGFloat)width
              sizeheight:(CGFloat)height;

/* 警告提示 */
+ (void)showAlertView:(NSString *)message;
// 窗口弹出动画
+ (void)shakeToShow:(UIView*)aView;

//六边形头像
+ (UIImage *)cutImageHex:(UIImage *)image;

//裁切图片为六边形
+ (UIImageView *)cutImageHex2:(UIImageView *)imageView;

//未通过验证的六边形头像 （未完成）
+ (UIImage *)noPassImageCut:(UIImage *)image waterImage:(UIImage *)waterImage str:(NSString *)str;

/** 计算两个经纬度之间的距离 返回单位千米 **/
//+(double)distanceBetweenOrderByLat1:(double)lat1 lat2:(double)lat2 lng1:(double)lng1 lng2:(double)lng2;

/**
 * 添加阴影
 * @param shadowView    添加阴影的view
 * @param color         阴影的颜色
 * @param radius        阴影的长度
 * @param opacity       阴影的透明度
 * @param cornerRadius  圆角
 */
+ (void)addShadow:(UIView *)shadowView color:(UIColor *)color radius:(CGFloat)radius opacity:(CGFloat)opacity cornerRadius:(CGFloat)cornerRadius;

//+ (NSData *)encodeWaveToAmr:(NSData *)data;
//+ (NSData *)encodeAmrToWave:(NSData *)data;

+ (NSString *)doGetRecordTime:(NSDate *)startDate recordEndDate:(NSDate *)endDate;

// 从URL字符串中获取文件名
+ (NSString *)getFilenameFromUrl:(NSString *)url;

// 设置红点
+ (UIView *)redView:(CGFloat)width andNumber:(NSInteger)number andView:(UIView *)viewNum;

+ (UIImageView *)startLoading:(UIImageView *)imageGif;

// 获取网络图片尺寸
+ (CGSize)getImageSizeWithURL:(NSURL *)url;



// 注销登录
+ (void)logOff;

/**
 *获取URL中的uri参数
 */
+ (NSDictionary *)GetUriParametersWithUrl:(NSString *)url;

// 唤醒登录
+ (void)needLoginView;

//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile;
@end
