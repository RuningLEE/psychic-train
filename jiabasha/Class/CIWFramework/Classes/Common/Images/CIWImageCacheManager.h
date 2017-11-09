//
//  CIWImageCacheManager.h
//  hupan
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CIWImageCacheManager : NSObject {
	NSOperationQueue *_imageQueue;
    NSMutableDictionary *_memoryCache;
    NSDate *_lastSuspendedTime;
}
@property (nonatomic,retain) NSOperationQueue *imageQueue;

+ (CIWImageCacheManager *)sharedManager;

/**清除某张图片的缓存*/
- (void)removeAImageWithUrl:(NSString *)url;

- (void)clearMemoryCache;
- (void)clearDiskCache;
- (void)restore;
- (void)saveImage:(UIImage*)image withUrl:(NSString*)url;
- (void)saveImage:(UIImage*)image withKey:(NSString*)key;
- (UIImage*)getImageFromCacheWithUrl:(NSString*)url;
- (UIImage*)getImageFromCacheWithKey:(NSString*)key;
- (BOOL)isImageInMemoryCacheWithUrl:(NSString*)url;
- (void)suspendImageLoading;
- (void)restoreImageLoading;
@end
