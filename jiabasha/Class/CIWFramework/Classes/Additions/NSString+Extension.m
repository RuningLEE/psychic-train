//
//  NSString+Extension.m
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

#pragma mark 对URL中的中文进行编码的方法
- (NSString *)stringEncodeWithURLString:(NSString *)theStr
{
    static NSString *result = nil;
    result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)theStr,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    return result;
}

#pragma mark 根据文字，字号及固定宽(固定高)来计算高(宽)
- (CGSize)sizeWithStringFontSize:(CGFloat)fontsize
                       sizewidth:(CGFloat)width
                      sizeheight:(CGFloat)height
{
    
    // 用何种字体显示
	UIFont *font = [UIFont systemFontOfSize:fontsize];

    CGSize expectedLabelSize = CGSizeZero;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment=NSTextAlignmentLeft;
        
        NSAttributedString *attributeText=[[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle}];
        CGSize labelsize = [attributeText boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        expectedLabelSize = CGSizeMake(ceilf(labelsize.width),ceilf(labelsize.height));
    }
	// 计算出显示完内容的最小尺寸
   
	return expectedLabelSize;
}

#pragma mark 根据文字，字体，字号及固定宽(固定高)来计算高(宽)
- (CGSize)sizeWithStringFont:(UIFont *)theFont
                   sizewidth:(CGFloat)width
                  sizeheight:(CGFloat)height
{
    
    CGSize expectedLabelSize = CGSizeZero;
    
    if (!self) {
//        self = @"";
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment=NSTextAlignmentLeft;
        
        NSAttributedString *attributeText=[[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:theFont,NSParagraphStyleAttributeName:paragraphStyle}];
        CGSize labelsize = [attributeText boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        expectedLabelSize = CGSizeMake(ceilf(labelsize.width),ceilf(labelsize.height));
    }
    // 计算出显示完内容的最小尺寸
	return expectedLabelSize;
}

#pragma mark 字符串数组转换成一个字符串
- (NSString *)stringWithStringArray:(NSArray *)tmpArr
{
    NSString *tmpStr = [[tmpArr valueForKey:@"description"] componentsJoinedByString:@","];
    return tmpStr;
}

#pragma mark 拼接一个get请求URL
- (NSString *)stringGETUrlWithDic:(NSDictionary *)theDic
{
    NSMutableString *tmpStrUrl = [NSMutableString stringWithString:self];
    NSArray *tmpArr = [theDic allKeys];

    for (int i = 0; i < [tmpArr count]; i++) {
        NSString *tmpStrKey = [tmpArr objectAtIndex:i];
        id tmpObject = [theDic objectForKey:tmpStrKey];
        if (i == 0) {
            [tmpStrUrl appendFormat:@"/?%@=%@",tmpStrKey,tmpObject];
        } else {
            [tmpStrUrl appendFormat:@"&%@=%@",tmpStrKey,tmpObject];
        }
    }
    return (NSString *)tmpStrUrl;
}

#pragma mark md5加密字符串
- (NSString *)stringMd5:(NSString *)str
{
	
	if (str == nil) {
		return nil;
	}
	const char *cstr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
	
	return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1],
			result[2], result[3],
			result[4], result[5],
			result[6], result[7],
			result[8], result[9],
			result[10], result[11],
			result[12], result[13],
			result[14], result[15]];
}

#pragma mark md5 加密文件内容
- (NSString *)stringMd5ForFileContent:(NSString *)file
{
	if( nil == file ) {
		return nil;
	}
	NSData * data = [NSData dataWithContentsOfFile:file];
	return [self stringMd5ForData:data];
}

#pragma mark md5 加密data
- (NSString *)stringMd5ForData:(NSData *)data
{
	if( !data || ![data length] ) {
		return nil;
	}
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	
    CC_MD5([data bytes], (CC_LONG)[data length], result);
	
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]];
}

#pragma mark 清除所有html标签
-(NSString *)stringFilterHTML
{
    if (!self) {
//        self = @"";
    }
    NSString *html = self;
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

#pragma mark 判断字符串中不能全是空格
- (BOOL)isAllBlank{
    if (self == nil) {
        return YES;
    }
    if (self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark 判断字符串中不能全是空格  且长度不为0   YES是正常数据 NO是空格，空Null
- (BOOL)isAllBlankWithLengthZero
{
    BOOL status = NO;
    if (self.length != 0 && ![self isAllBlank]) {
        status = YES;
    }
    return status;
}

@end
