//
//  CIWImageCacheManager.m
//  hupan
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CIWImageCacheManager.h"
#import "CIWGobalPaths.h"
#import "CIWObjectSingleton.h"

@interface CIWImageCacheManager()
- (NSString*)encodeURL:(NSString *)string;
- (NSString*)getKeyFromUrl:(NSString*)url;
- (NSString*)getPathByFileName:(NSString *)fileName;
- (void)saveToMemory:(UIImage*)image forKey:(NSString*)key;
- (UIImage*)getImageFromMemoryCache:(NSString*)key;
- (BOOL)isImageInMemoryCache:(NSString*)key;
- (NSString *)getImageFolder;
- (BOOL)createDirectorysAtPath:(NSString *)path;
- (void)checkRequestQueueStatus;
@end

@implementation CIWImageCacheManager

CIWOBJECT_SINGLETON_BOILERPLATE(CIWImageCacheManager, sharedManager)
#pragma mark - Object lifecycle

- (id)init{
    self = [super init];
	if (self) {
		[self restore];
	}
    
    [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(checkRequestQueueStatus) userInfo:nil repeats:YES];
	return self;
}

- (void)restore{
    [self registerMemoryWarningNotification];
    _imageQueue = [[NSOperationQueue alloc] init];
    [_imageQueue setMaxConcurrentOperationCount:20];
    _memoryCache = nil;
    _memoryCache = [[NSMutableDictionary alloc] init];
    NSString *path = [self getImageFolder];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self createDirectorysAtPath:path];
    }
}

- (void)dealloc{
    _memoryCache = nil;
    _imageQueue = nil;
    _lastSuspendedTime = nil;
}

#pragma mark - private methods

- (void)registerMemoryWarningNotification{
    // Subscribe to app events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearMemoryCache)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];    
  
    #ifdef __IPHONE_4_0
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported)
    {
        // When in background, clean memory in order to have less chance to be killed
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemoryCache)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    #endif
}

- (NSString*)encodeURL:(NSString *)string{
	NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
	if (newString) {
		return newString;
	}
	return @"";
}

- (BOOL)createDirectorysAtPath:(NSString *)path{
    @synchronized(self){
        NSFileManager* manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:path]) {
            NSError *error = nil;
            if (![manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
//                CIWDERROR(@"error : %@", error);
                return NO;
            }
        }
    }
    return YES;
}
- (NSString *)getImageFolder{
	return CIWPathForCacheResource(@"images");
}

- (NSString *)getPathByFileName:(NSString *)fileName{
	return [NSString stringWithFormat:@"%@/%@",[self getImageFolder],fileName];
}

- (NSString*)getKeyFromUrl:(NSString*)url{
    return [self encodeURL:url];
}

- (void)saveToMemory:(UIImage*)image forKey:(NSString*)key{
    if (image) {
        @try {
            [_memoryCache setObject:image forKey:key];
        }
        @catch (NSException *exception) {
            NSAssert(0, @"加载图片异常:%@",exception);
        }
    }
}

- (UIImage*)getImageFromMemoryCache:(NSString*)key{
    return _memoryCache[key];
}

- (BOOL)isImageInMemoryCacheWithUrl:(NSString*)url{
    return [self isImageInMemoryCache:[self getKeyFromUrl:url]];
}

- (BOOL)isImageInMemoryCache:(NSString*)key{
    return (nil != [self getImageFromMemoryCache:key]);
}
// make sure queue will not suspended for too long
- (void)checkRequestQueueStatus{
    if(!_lastSuspendedTime || [_imageQueue operationCount] == 0 ){
        return;
    }
    if ([[NSDate date] timeIntervalSinceDate:_lastSuspendedTime] > 5.0) {
        [self restoreImageLoading];
    }
}
#pragma mark - public methods
- (void)saveImage:(UIImage*)image withUrl:(NSString*)url{
    [self saveImage:image withKey:[self getKeyFromUrl:url]];
}

- (void)saveImage:(UIImage*)image withKey:(NSString*)key{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    NSData* imageData = UIImagePNGRepresentation(image);
//    NSString *imageFilePath = [self getPathByFileName:key];
//    [imageData writeToFile:imageFilePath atomically:YES];
//    [self saveToMemory:image forKey:key];
//    [pool drain];
    @autoreleasepool {
        NSData* imageData = UIImagePNGRepresentation(image);
        NSString *imageFilePath = [self getPathByFileName:key];
        [imageData writeToFile:imageFilePath atomically:YES];
        [self saveToMemory:image forKey:key];
    }
}

- (UIImage*)getImageFromCacheWithUrl:(NSString*)url{
    return [self getImageFromCacheWithKey:[self getKeyFromUrl:url]];
}

- (UIImage*)getImageFromCacheWithKey:(NSString*)key{
    if ([self isImageInMemoryCache:key]) {
        return [self getImageFromMemoryCache:key];
    }else{
        NSString *imageFilePath = [self getPathByFileName:key];
        UIImage* image = [UIImage imageWithContentsOfFile:imageFilePath];
        if (image) {
            [self saveToMemory:image forKey:key];
        }
        return image;
    }
}

- (void)clearDiskCache{
    NSString *imageFolderPath = [self getImageFolder];
    [[NSFileManager defaultManager] removeItemAtPath:imageFolderPath error:nil];
    [self createDirectorysAtPath:imageFolderPath];
}


- (void)removeAImageWithUrl:(NSString *)url
{
    NSString *key = [self getKeyFromUrl:url];
    [_memoryCache removeObjectForKey:key];
    
    NSString *imagePath = [self getPathByFileName:key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:imagePath error:nil];
    
}

- (void)clearMemoryCache{
    _memoryCache = nil;
    _memoryCache = [[NSMutableDictionary alloc] init];
}

- (void)suspendImageLoading{
    if ([_imageQueue isSuspended]) {
        return;
    }
    [_imageQueue setSuspended:YES];
//    CIWDINFO(@"image request queue suspended");
    _lastSuspendedTime = nil;
    _lastSuspendedTime = [NSDate date];
}
- (void)restoreImageLoading{
    [_imageQueue setSuspended:NO];
    _lastSuspendedTime = nil;
//    CIWDINFO(@"image request queue restored");
}
@end
