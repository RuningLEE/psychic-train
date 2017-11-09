//
//  CIWImageManager.m
// 
//  Copyright 2010 iTotem. All rights reserved.
//

#import "CIWImageView.h"
#import "UIUtil.h"
#import "DataEnvironment.h"
#import "CIWImageCacheManager.h"

@interface CIWImageView()
-(void)showLoading;
-(void)hideLoading;
-(void)handleTapGesture:(UITapGestureRecognizer *)recognizer;
@end

@implementation CIWImageView


+ (id)copyWithZone:(struct _NSZone *)zone {
    
    CIWImageView *copy = [[[self class] allocWithZone:zone]init];
    
    
    return copy;

}

- (void)dealloc{
    [self cancelImageRequest];
    _imageDataOperation.delegate = nil;
    _imageDataOperation = nil;
    
    _delegate = nil;
    
    _indicator = nil;
    _imageUrl = nil;
}

- (id)init{
    self = [super init];
	if (self) {
        self.indicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.exclusiveTouch = YES;
	}
	return self;
}

- (void)awakeFromNib
{
    self.exclusiveTouch = YES;
}

- (void)setDefaultImage:(UIImage*)defaultImage{
	self.image = defaultImage;
}

- (void)cancelImageRequest{
    if (_imageDataOperation && ([_imageDataOperation isExecuting] || [_imageDataOperation isReady])) {
        [_imageDataOperation cancel];
//        CIWDINFO(@"image request is canceled,url:%@", _imageUrl);
    }
    [self hideLoading];
}

- (void)loadImage:(NSString*)url{
//    [self setContentMode:UIViewContentModeScaleAspectFit];
    self.clipsToBounds = YES;
    
	if( url==nil || [url isEqualToString:@""] ){
		return;	
    }
    _imageUrl = nil;
    
    //测试接口过滤图片url 后面的-perx
//    url = [self filterImageUrlWithUrl:url];

    
    _imageUrl = url;
    
    
    [self cancelImageRequest];
    
    
    
    if ([[CIWImageCacheManager sharedManager] isImageInMemoryCacheWithUrl:_imageUrl]) {
        [self imageLoaded:[[CIWImageCacheManager sharedManager] getImageFromCacheWithUrl:_imageUrl]];
//        self.image = [[CIWImageCacheManager sharedManager] getImageFromCacheWithUrl:_imageUrl];
//        [self hideLoading];
    } else {
        BOOL showShowLoading = YES;
        if (self.image) {
            showShowLoading = NO;
        }
        if (showShowLoading) {
            [self showLoading];
        }
        _imageDataOperation = nil;
        _imageDataOperation = [[CIWImageDataOperation alloc] initWithURL:_imageUrl delegate:self];
        
        [[CIWImageCacheManager sharedManager].imageQueue addOperation:_imageDataOperation];
    }
}


//过滤测试接口URL后面的 -perx 字符（测试接口有问题，图片无法显示）
- (NSString *)filterImageUrlWithUrl:(NSString *)url
{

    NSRange range = [url rangeOfString:@"-per"];
    if (range.location != NSNotFound) {
        range.length = range.location;
        range.location = 0;
        url = [url substringWithRange:range];
    }

    return url;
    
}

- (void)setEnableTapEvent:(BOOL)enableTapEvent{
    self.exclusiveTouch = YES;

    
    _enableTapEvent = enableTapEvent;
    if (_enableTapEvent) {
        [self setUserInteractionEnabled:YES];
        if (!_tapGestureRecognizer) {
            _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        }
//        _tapGestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:_tapGestureRecognizer];
    }else{
        if (_tapGestureRecognizer) {
            [self removeGestureRecognizer:_tapGestureRecognizer];
            _tapGestureRecognizer = nil;
        }
    }
}

-(void)setIndicatorViewStyle:(UIActivityIndicatorViewStyle)style{
    _indicatorViewStyle = style;
    [_indicator setActivityIndicatorViewStyle:style];
}

-(void)showLoading{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:_indicatorViewStyle];
        _indicator.center = CGRectGetCenter(self.bounds);
        [_indicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    }
    _indicator.hidden = NO;
    if(!_indicator.superview){
        [self addSubview:_indicator];
    }
    [_indicator startAnimating];
}
-(void)hideLoading{
    if (_indicator) {
        [_indicator stopAnimating];
        _indicator.hidden = YES;
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer{
    if (_delegate && [_delegate respondsToSelector:@selector(imageClicked:)]) {
        [_delegate imageClicked:self];
	}
}

#pragma mark - CIWImageDataOperationDelegate

-(void)imageDataOperation:(CIWImageDataOperation*)operation loadedWithUrl:(NSString*)url withImage:(UIImage *)image{
    if (operation.imageUrl == _imageUrl) {
        [self performSelectorOnMainThread:@selector(imageLoaded:) withObject:image waitUntilDone:YES];
    }
}

- (void)imageLoaded:(UIImage *)image{
    
    [self hideLoading];
    self.image = image;
	if (_delegate && [_delegate respondsToSelector:@selector(imageLoaded:)]) {
        [_delegate imageLoaded:self];
	}
}
@end

