//
//  CIWImageDataOperation.h
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol CIWImageDataOperationDelegate;

@interface CIWImageDataOperation : NSOperation {
    NSString *_imageUrl;
    CGSize _targetSize;
}
@property (nonatomic,assign) id<CIWImageDataOperationDelegate> delegate;
@property (nonatomic,retain) NSString *imageUrl;
@property (nonatomic,assign) CGSize targetSize;

- (id)initWithURL:(NSString *)url delegate:(id<CIWImageDataOperationDelegate>)delegate;

@end
@protocol CIWImageDataOperationDelegate <NSObject>
-(void)imageDataOperation:(CIWImageDataOperation*)operation loadedWithUrl:(NSString*)url withImage:(UIImage*)image;
@end