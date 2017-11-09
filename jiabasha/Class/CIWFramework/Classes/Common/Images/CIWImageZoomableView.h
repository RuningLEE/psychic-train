//
//  ImageScrollView.h
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CIWImageView.h"
@protocol CIWImageZoomableViewDelegate;
@interface CIWImageZoomableView : UIScrollView <UIScrollViewDelegate> {
    CIWImageView *_imageView;
    int _index;
    BOOL _canClickScale; 
}
@property (nonatomic, assign) int index;
@property (nonatomic, assign) id<CIWImageZoomableViewDelegate> tapDelegate;
@property (nonatomic, retain) CIWImageView *imageView;
- (void)displayImageWithUrl:(NSString *)imageUrl;
- (void)displayImage:(UIImage *)image;

- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;
- (void)cancelImageRequest;
- (void)setMaxMinZoomScalesForCurrentBounds;

- (void)zoomWithTouchPoint:(CGPoint)point;
- (void)responseDoubleTap:(CGPoint)point;

@end
@protocol CIWImageZoomableViewDelegate <NSObject>
@optional
- (void)imageZoomableViewSingleTapped:(CIWImageZoomableView*)imageZoomableView;

@end