//
//  ImageScrollView.h
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "CIWImageZoomableView.h"

@implementation CIWImageZoomableView
@synthesize index = _index;
@synthesize tapDelegate = _tapDelegate;
@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initView];
}

- (void)initView{
    _canClickScale = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = YES;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.delegate = self;
    _imageView = [[CIWImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth
    | UIViewAutoresizingFlexibleHeight
    | UIViewAutoresizingFlexibleTopMargin
    | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:_imageView];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _imageView.frame = self.bounds;
}

- (void)dealloc{
    _tapDelegate = nil;
}

#pragma mark - Override layoutSubviews to center content

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width){
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }else{
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height){
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }else{
        frameToCenter.origin.y = 0;
    }
    
    _imageView.frame = frameToCenter;
}

#pragma mark - UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

#pragma mark - Configure scrollView to display new image 

- (void)displayImageWithUrl:(NSString *)imageUrl
{
    _imageView.image = nil;
    [_imageView loadImage:imageUrl];
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}

- (void)displayImage:(UIImage *)image
{
    [_imageView setImage:image];
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}

- (void)cancelImageRequest{
    [_imageView cancelImageRequest];
}

#pragma mark - Methods called during rotation to preserve the zoomScale and the visible portion of the image

// returns the center point, in image coordinate space, to try to restore after rotation. 
- (CGPoint)pointToCenterAfterRotation{
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    return [self convertPoint:boundsCenter toView:_imageView];
}

- (void)setMaxMinZoomScalesForCurrentBounds{
    if (self.bounds.size.width == 320) {
        // is landscape
        self.maximumZoomScale = 3;
        self.minimumZoomScale = 1;
    }else{
        self.maximumZoomScale = 2;
        self.minimumZoomScale = 1;
    }
}
// returns the zoom scale to attempt to restore after rotation. 
- (CGFloat)scaleToRestoreAfterRotation{
    CGFloat contentScale = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (contentScale <= self.minimumZoomScale + FLT_EPSILON){
        contentScale = 0;
    }    
    return contentScale;
}

- (CGPoint)maximumContentOffset{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset{
    return CGPointZero;
}

// Adjusts content offset and scale to try to preserve the old zoomscale and center.
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale{    
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    self.zoomScale = MIN(self.maximumZoomScale, MAX(self.minimumZoomScale, oldScale));
    
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:oldCenter fromView:_imageView];
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0, 
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    offset.x = MAX(minOffset.x, MIN(maxOffset.x, offset.x));
    offset.y = MAX(minOffset.y, MIN(maxOffset.y, offset.y));
    self.contentOffset = offset;
}
#pragma mark - handle double tap and single tap

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    NSUInteger tapCount = [touch tapCount];
    switch (tapCount) {
        case 1:
            [self performSelector:@selector(singleTapBegan:) withObject:[NSArray arrayWithObjects:touches, event,nil] afterDelay:.3];
            break;
        case 2:
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            break;
        default:
            break;
    }
}



- (void)singleTapBegan:(NSArray *)sender{
    [[self nextResponder] touchesBegan:[sender objectAtIndex:0] withEvent:[sender objectAtIndex:1]];
}

-(void)singleTapEnd:(NSArray *)sender{
    [[self nextResponder] touchesEnded:[sender objectAtIndex:0] withEvent:[sender objectAtIndex:1]];
    CIWDINFO(@"single tap");
    if (_tapDelegate && [_tapDelegate respondsToSelector:@selector(imageZoomableViewSingleTapped:) ]) {
        [_tapDelegate imageZoomableViewSingleTapped:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    NSUInteger tapCount = [touch tapCount];
    if(tapCount == 2){
        UITouch *touch = [touches anyObject];
        CGPoint centerPoint = [touch locationInView:self];
        [self responseDoubleTap:centerPoint];
    }else if(tapCount == 1){
        [self performSelector:@selector(singleTapEnd:) withObject:[NSArray arrayWithObjects:touches, event,nil] afterDelay:.3];
    }
}

- (void)zoomWithTouchPoint:(CGPoint )point
{
    CGPoint origin = self.contentOffset;
    point = CGPointMake(point.x - origin.x, point.y - origin.y);
    
    [self setZoomScale:self.maximumZoomScale animated:YES];
    [self setContentOffset:CGPointMake((self.maximumZoomScale - 1)*point.x, (self.maximumZoomScale - 1)*point.y) animated:YES];
}


- (void)responseDoubleTap:(CGPoint)point
{
    CIWDINFO(@"double tap");
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.zoomScale != self.minimumZoomScale) {
        CGFloat scaleTime = (self.zoomScale - self.minimumZoomScale)/self.zoomScale/2;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:scaleTime];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.zoomScale = self.minimumZoomScale;
        [UIView commitAnimations];
    }else{
        if (!_canClickScale) {
            return;
        }
        CGPoint centerPoint = point;
        CGPoint origin = self.contentOffset;
        centerPoint = CGPointMake(centerPoint.x - origin.x, centerPoint.y - origin.y);
        
        [self setZoomScale:self.maximumZoomScale animated:YES];
        [self setContentOffset:CGPointMake((self.maximumZoomScale - 1)*centerPoint.x, (self.maximumZoomScale - 1)*centerPoint.y) animated:YES];
        
    }
}

@end
