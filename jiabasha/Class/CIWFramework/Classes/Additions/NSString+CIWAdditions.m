//
//  NSString+CIWAdditions.m
//  HunBaSha
//
//  Created by GarrettGao on 15/4/20.
//  Copyright (c) 2015年 hunbohui. All rights reserved.
//

#import "NSString+CIWAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CIWAdditions)

/**
 *  获取字符串排列的行数
 *  @font 显示文字大小
 *  @lineWidth 显示问题的宽度
 */
- (NSInteger)numberOfLinesWithFont:(UIFont*)font
                     withLineWidth:(CGFloat)lineWidth{
    CGSize size = [self getSizeWithFont:font constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)];
    NSInteger lines = size.height / [font CIWLineHeight];
    return lines;
}

/**
 *  获取字符串排列高度
 *  @font 显示字体大小
 *  @lineWidth 文字显示的宽度
 */
- (CGFloat)getHeightWithFont:(UIFont*)font
               withLineWidth:(CGFloat)lineWidth{
    CGSize size = [self getSizeWithFont:font constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)];
    return size.height;
    
}

/**
 *  获取字符串排列高度
 *  @font 显示字体大小
 *  @lineWidth 文字显示的宽度
 *  @lineBreakMode label类型
 */
- (CGFloat)getHeightWithFont:(UIFont*)font
               withLineWidth:(CGFloat)lineWidth
           withLineBreakMode:(NSLineBreakMode)lineBreakMode{
    CGSize size = [self getSizeWithFont:font constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX) withLineBreakMode:lineBreakMode];
    return size.height;
    
}


/**
 *  获取文字排列 Size
 *  @font 显示字体大小
 *  @size 最大区限
 */
- (CGSize)getSizeWithFont:(UIFont *)font
        constrainedToSize:(CGSize)size
{
    return [self getSizeWithFont:font
               constrainedToSize:size
               withLineBreakMode:NSLineBreakByCharWrapping];
}

/**
 *  获取文字排列 Size
 *  @font 显示字体大小
 *  @size 最大区限
 *  @lineBreakMode label类型
 */
- (CGSize)getSizeWithFont:(UIFont *)font
        constrainedToSize:(CGSize)size
        withLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    
    NSString *text = [NSString stringWithString:self];
    
    text = text ? text : @"";
    font = font ? font : [UIFont systemFontOfSize:14];
    
    lineBreakMode = lineBreakMode?:NSLineBreakByCharWrapping;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSAttributedString *attributeText=[[NSAttributedString alloc]
                                           initWithString:text
                                           attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle}
                                           ];
        CGSize labelsize = [attributeText boundingRectWithSize:CGSizeMake(size.width, size.height)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil
                            ].size;
        return CGSizeMake(ceilf(labelsize.width),ceilf(labelsize.height) + ([self stringContainsEmoji]?6:0));
        
    }
    return CGSizeZero;
}
    
    

/**是否包含emoji表情*/
- (BOOL)stringContainsEmoji
{
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

/** md5加密*/
- (NSString *)md5{
    const char *concat_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, (CC_LONG)strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
    
}


/**  判断某个字符串是否包含某个字符串*/
- (BOOL)isIncludeTheString:(NSString *)string
{
    if(string){
        NSRange range = [self rangeOfString:string];//判断字符串
        return (range.location !=NSNotFound);
    }else{
        return NO;
    }
}



/**
 *encode
 */
- (NSString*)encode{
    NSString *encodeString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    return encodeString? : @"";
}


/**
 *deCode
 */
- (NSString *)decode
{
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

/**截取某两个字符间的字符串*/
- (NSString *)getStringWithStarString:(NSString *)star
                  withEndString:(NSString *)end
{
    if(star && end){
        NSString *text = nil;
        NSScanner *theScanner = [NSScanner scannerWithString:self];
        if([theScanner isAtEnd] == NO){
            [theScanner scanUpToString:star intoString:NULL] ;
            [theScanner scanUpToString:end intoString:&text] ;
            return [NSString stringWithFormat:@"%@%@", text,end];
        }
    }
    return nil;
}


/**过滤html标签*/
- (NSString *)removeHTML {
    NSScanner *theScanner;
    NSString *text = nil;
    NSString *html = self;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@" "];
    }
    return html;
}

/**删除字符串的前后空格*/
- (NSString *)getNotWhitespace
{
    return (self?[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]:nil);
}


/**字符串至少一个字符*/
- (NSString *)notNoLength
{
    return (self && self.length) ? self : @"-";
}


- (NSString *)br
{
    NSString *new = [self stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    NSString *new2 = [new stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    return new2;
}

- (NSString *)getTimestamp
{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:self];
    
    
    NSString *timeStr = [dateFormatter stringFromDate:destDate];

    return timeStr;
    
}

- (NSDictionary *)cookieMap{
    NSMutableDictionary *cookieMap = [NSMutableDictionary dictionary];
    
    NSArray *cookieKeyValueStrings = [self componentsSeparatedByString:@";"];
    for (NSString *cookieKeyValueString in cookieKeyValueStrings) {
        //找出第一个"="号的位置
        NSRange separatorRange = [cookieKeyValueString rangeOfString:@"="];
        
        if (separatorRange.location != NSNotFound &&
            separatorRange.location > 0 &&
            separatorRange.location < ([cookieKeyValueString length] - 1)) {
            //以上条件确保"="前后都有内容，不至于key或者value为空
            
            NSRange keyRange = NSMakeRange(0, separatorRange.location);
            NSString *key = [cookieKeyValueString substringWithRange:keyRange];
            NSString *value = [cookieKeyValueString substringFromIndex:separatorRange.location + separatorRange.length];
            
            key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [cookieMap setObject:value forKey:key];
            
        }
    }
    return cookieMap;
}

@end
