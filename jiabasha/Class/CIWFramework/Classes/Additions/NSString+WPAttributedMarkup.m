//
//  NSString+WPAttributedMarkup.m
//  SonoRoute
//
//  Created by HBH on 07/06/2014.
//  Copyright (c) 2014 Nigel z. All rights reserved.
//

#import "NSString+WPAttributedMarkup.h"
#import "NSMutableString+TagReplace.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>


@interface MMTextAttachment : NSTextAttachment
{
    
}
@end
@implementation MMTextAttachment
//I want my emoticon has the same size with line's height
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex NS_AVAILABLE_IOS(7_0)
{
    return CGRectMake( 0 , 0 , lineFrag.size.height , lineFrag.size.height );
}
@end

NSString* kWPAttributedMarkupLinkName = @"WPAttributedMarkupLinkName";

@implementation NSString (WPAttributedMarkup)

-(NSAttributedString*)attributedStringWithStyleBook:(NSDictionary*)fontbook
{
    // Find string ranges
    NSMutableArray* tags = [[NSMutableArray alloc] initWithCapacity:16];
    NSMutableString* ms = [self mutableCopy];
    
    [ms replaceOccurrencesOfString:@"<br>" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"<br />" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, ms.length)];
    
    [ms replaceAllTagsIntoArray:tags];
    NSMutableAttributedString* as = [[NSMutableAttributedString alloc] initWithString:ms];
    // Setup base attributes
    [as setAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone]} range:NSMakeRange(0,[as length])];
    
    NSObject* bodyStyle = fontbook[@"body"];
    if (bodyStyle) {
        [self styleAttributedString:as range:NSMakeRange(0, as.length) withStyle:bodyStyle withStyleBook:fontbook];
    }

    for (NSDictionary* tag in tags) {
        NSString* t = tag[@"tag"];
        NSNumber* loc = tag[@"loc"];
        NSNumber* endloc = tag[@"endloc"];
        if (loc != nil && endloc != nil) {
            NSRange range = NSMakeRange([loc integerValue], [endloc integerValue] - [loc integerValue]);
            NSObject* style = fontbook[t];
            if (style) {
                [self styleAttributedString:as range:range withStyle:style withStyleBook:fontbook];
            }
        }
    }
    
    return as;
}

-(void)styleAttributedString:(NSMutableAttributedString*)as range:(NSRange)range withStyle:(NSObject*)style withStyleBook:(NSDictionary*)styleBook
{
    if ([style isKindOfClass:[NSArray class]]) {
        for (NSObject* subStyle in (NSArray*)style) {
            [self styleAttributedString:as range:range withStyle:subStyle withStyleBook:styleBook];
        }
    }
    else if ([style isKindOfClass:[NSDictionary class]]) {
        [self setStyle:(NSDictionary*)style range:range onAttributedString:as];
    }
    else if ([style isKindOfClass:[UIFont class]]) {
        [self setFont:(UIFont*)style range:range onAttributedString:as];
    }
    else if ([style isKindOfClass:[UIColor class]]) {
        [self setTextColor:(UIColor*)style range:range onAttributedString:as];
    } else if ([style isKindOfClass:[NSURL class]]) {
        [self setLink:(NSURL*)style range:range onAttributedString:as];
    } else if ([style isKindOfClass:[NSString class]]) {
        [self styleAttributedString:as range:range withStyle:styleBook[(NSString*)style] withStyleBook:styleBook];
    } else if ([style isKindOfClass:[UIImage class]]) {
        MMTextAttachment* attachment = [[MMTextAttachment alloc] init];
        attachment.image = (UIImage*)style;
//        [as replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
        NSAttributedString * textAttachmentString = [NSAttributedString attributedStringWithAttachment:attachment] ;
        [as insertAttributedString:textAttachmentString atIndex:range.location];
    }
}


-(void)setStyle:(NSDictionary*)style range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    for (NSString* key in [style allKeys]) {
        [self setTextStyle:key withValue:style[key] range:range onAttributedString:as];
    }
}

-(void)setFont:(UIFont*)font range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    [self setFontName:font.fontName size:font.pointSize range:range onAttributedString:as];
}


-(void)setFontName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    // kCTFontAttributeName
    CTFontRef aFont = CTFontCreateWithName((__bridge CFStringRef)fontName, size, NULL);
    if (aFont)
    {
        [as removeAttribute:(__bridge NSString*)kCTFontAttributeName range:range]; // Work around for Apple leak
        [as addAttribute:(__bridge NSString*)kCTFontAttributeName value:(__bridge id)aFont range:range];
        CFRelease(aFont);
    }
}

-(void)setTextColor:(UIColor*)color range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    // kCTForegroundColorAttributeName
    [as removeAttribute:NSForegroundColorAttributeName range:range];
    [as addAttribute:NSForegroundColorAttributeName value:color range:range];
}

-(void)setTextStyle:(NSString*)styleName withValue:(NSObject*)value range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    [as removeAttribute:styleName range:range]; // Work around for Apple leak
    [as addAttribute:styleName value:value range:range];
}

-(void)setLink:(NSURL*)url range:(NSRange)range onAttributedString:(NSMutableAttributedString*)as
{
    [as removeAttribute:kWPAttributedMarkupLinkName range:range]; // Work around for Apple leak
    if (&link)
    {
        [as addAttribute:kWPAttributedMarkupLinkName value:[url absoluteString] range:range];
    }
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
