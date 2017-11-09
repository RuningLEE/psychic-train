//
//  CIWImageDataOperation.m
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CIWImageDataOperation.h"
#import "CIWImageCacheManager.h"
#import "UIImage+CIWAdditions.h"
#import "CIWNetworkTrafficManager.h"

@implementation CIWImageDataOperation

- (void)dealloc {
    [self cancel];
    _delegate = nil;
    _imageUrl = nil;
}

- (id)initWithURL:(NSString *)url delegate:(id<CIWImageDataOperationDelegate>)delegate{
    self = [super init];
	if (self) {
		_imageUrl = url;
		_delegate = delegate;
        _targetSize = CGSizeZero;
	}
	return self;
}
- (void)cancel{
    [super cancel];
    _delegate = nil;
}
- (void)main{
    UIImage *image = [[CIWImageCacheManager sharedManager] getImageFromCacheWithUrl:_imageUrl];
    
    
    BOOL status = (!image || [image isKindOfClass:[NSNull class]]) ? NO : YES;
    
	if(!status){
//        CIWDINFO(@"loading image from web:%@",_imageUrl);
		NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
		if( imageData!=nil){
			image = [UIImage imageWithData:imageData];
            [[CIWImageCacheManager sharedManager] saveImage:[UIImage imageWithData:imageData] withUrl:_imageUrl];
            [[CIWNetworkTrafficManager sharedManager] logTrafficOut:[_imageUrl lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
            [[CIWNetworkTrafficManager sharedManager] logTrafficIn:[imageData length]];
            status = YES;
		}
	}
    if (status && _delegate && [_delegate respondsToSelector:@selector(imageDataOperation:loadedWithUrl:withImage:)]) {
        if (_targetSize.height > 0 && _targetSize.width > 0) {
            [_delegate imageDataOperation:self 
                            loadedWithUrl:_imageUrl
                                withImage:[image imageFitInSize:_targetSize]];
        }else{
            
            [_delegate imageDataOperation:self 
                            loadedWithUrl:_imageUrl
                                withImage:image];
        }
    }
}
@end
