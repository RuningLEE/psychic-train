//
//  NSString+CIWAdditions.h
//  HunBaSha
//
//  Created by GarrettGao on 15/4/20.
//  Copyright (c) 2015年 hunbohui. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (CIWAdditions)


/**
 *  获取字符串排列的行数
 *  @font 显示文字大小
 *  @lineWidth 显示问题的宽度
 */
- (NSInteger)numberOfLinesWithFont:(UIFont*)font
                     withLineWidth:(CGFloat)lineWidth;


/**
 *  获取字符串排列高度
 *  @font 显示字体大小
 *  @lineWidth 文字显示的宽度
 */
- (CGFloat)getHeightWithFont:(UIFont*)font
            withLineWidth:(CGFloat)lineWidth;


/**
 *  获取字符串排列高度
 *  @font 显示字体大小
 *  @lineWidth 文字显示的宽度
 *  @lineBreakMode label类型
 */
- (CGFloat)getHeightWithFont:(UIFont*)font
               withLineWidth:(CGFloat)lineWidth
           withLineBreakMode:(NSLineBreakMode)lineBreakMode;


/**
 *  获取文字排列 Size
 *  @font 显示字体大小
 *  @size 最大区限
 */
- (CGSize)getSizeWithFont:(UIFont *)font
        constrainedToSize:(CGSize)size ;


/**
 *  获取文字排列 Size
 *  @font 显示字体大小
 *  @size 最大区限
 *  @lineBreakMode label类型
 */
- (CGSize)getSizeWithFont:(UIFont *)font
        constrainedToSize:(CGSize)size
        withLineBreakMode:(NSLineBreakMode)lineBreakMode;


/**
 * md5加密
 */
- (NSString *)md5;



/**  判断某个字符串是否包含某个字符串*/
- (BOOL)isIncludeTheString:(NSString *)string;


/**enCode*/
- (NSString*)encode;


/**
 *decode
 */
- (NSString *)decode;


/**是否包含emoji表情*/
- (BOOL)stringContainsEmoji;


/**截取某两个字符间的字符串*/
- (NSString *)getStringWithStarString:(NSString *)star
                        withEndString:(NSString *)end;


/**过滤html标签*/
- (NSString *)removeHTML;

/**删除字符串的前后空格*/
- (NSString *)getNotWhitespace;

/**字符串至少一个字符*/
- (NSString *)notNoLength;

/**过滤 网页中的 < Br>标签，改为\n换行*/
- (NSString *)br;

/**字符串转换时间戳*/
- (NSString *)getTimestamp;

/**解析字符串中的cookies*/
- (NSDictionary *)cookieMap;

@end
