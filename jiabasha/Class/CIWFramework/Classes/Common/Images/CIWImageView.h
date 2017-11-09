//
//  CIWImageView.h
//
//  Copyright 2010 iTotem. All rights reserved.
//
#import "CIWImageDataOperation.h"

@class CIWImageView;
@protocol CIWImageViewDelegate <NSObject>
@optional
- (void)imageLoaded:(CIWImageView *)imageView;
- (void)imageClicked:(CIWImageView *)imageView;
@end

@interface CIWImageView : UIImageView <CIWImageDataOperationDelegate, UIGestureRecognizerDelegate>{
    UIActivityIndicatorView *_indicator;
    UIActivityIndicatorViewStyle _indicatorViewStyle;
    NSString *_imageUrl;
    CIWImageDataOperation *_imageDataOperation;
    UITapGestureRecognizer *_tapGestureRecognizer;
    
    //响应Tap方法
    BOOL _enableTapEvent;
}
@property (nonatomic,retain,readonly) NSString *imageUrl;
@property (nonatomic, retain) NSString *imgID;
@property (nonatomic,assign) id<CIWImageViewDelegate> delegate;
@property (nonatomic,assign) BOOL enableTapEvent;
@property (nonatomic,assign) UIActivityIndicatorViewStyle indicatorViewStyle;
@property (nonatomic, assign) NSInteger index;


- (void)loadImage:(NSString*)url;
- (void)setDefaultImage:(UIImage*)defaultImage;
- (void)cancelImageRequest;

@end
