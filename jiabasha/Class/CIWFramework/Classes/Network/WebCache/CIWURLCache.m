//
//  CIWURLCache.m
//  CIWFrameWork
//
//  Created by GarrettGao on 15/7/1.
//  Copyright (c) 2015年 MyCompany. All rights reserved.
//

#import "CIWURLCache.h"
#import "Reachability.h"
#import "CIWGobalPaths.h"
@implementation CIWURLCache

/**
 *初始化NSURLCache类
 @param memoryCapacity:给予缓存的内存容量
 @param diskCapacity:给予缓存的磁盘容量
 @param path:加载内容的缓存地址
 @param cacheTime:缓存的时间（以秒为单位）
 */
- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path cacheTime:(NSInteger)cacheTime {
    if (self = [self initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path]) {
        self.cacheTime = cacheTime;
        if (path)
            self.diskPath = path;
        else
            self.diskPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        self.responseDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearWebMemoryCache)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanWebDiskCache)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanWebDiskCache)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        
    }
    return self;
}


- (void)dealloc
{
    _diskPath = nil;
    _responseDictionary = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


//关键方法
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    if ([request.HTTPMethod compare:@"GET"] != NSOrderedSame) {
        return [super cachedResponseForRequest:request];
    }
    //如果是webview的请求，才会在这里做缓存
    NSString *userAgent = [request.allHTTPHeaderFields objectForKey:@"User-Agent"];
    if (![userAgent isIncludeTheString:kUserAgent]){
        return [super cachedResponseForRequest:request];
    }
    return [self dataFromRequest:request];
}


- (void)removeAllCachedResponses {
    [super removeAllCachedResponses];
    [self deleteCacheFolder];
}

- (void)removeCachedResponseForRequest:(NSURLRequest *)request {
    [super removeCachedResponseForRequest:request];
    
    NSString *url = request.URL.absoluteString;
    NSString *fileName = [self cacheRequestFileName:url];
    NSString *otherInfoFileName = [self cacheRequestOtherInfoFileName:url];
    NSString *filePath = [self cacheFilePath:fileName withIsOtherInfo:NO];
    NSString *otherInfoPath = [self cacheFilePath:otherInfoFileName withIsOtherInfo:YES];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    [fileManager removeItemAtPath:otherInfoPath error:nil];
}

#pragma mark - custom url cache

- (NSString *)cacheFolder {
    return @"CIWWebCache";
}

- (NSString *)cacheOtherInfoFolder{
    return @"OtherInfo";
}

- (void)deleteCacheFolder {
    NSString *path = [NSString stringWithFormat:@"%@/%@", self.diskPath, [self cacheFolder]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}

- (NSString *)cacheFilePath:(NSString *)file withIsOtherInfo:(BOOL)isInfo {
    NSString *path = [NSString stringWithFormat:@"%@/%@", self.diskPath, [self cacheFolder]];
    NSString *otherInfoPath = [NSString stringWithFormat:@"%@/%@/%@", self.diskPath, [self cacheFolder],[self cacheOtherInfoFolder]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (!([fileManager fileExistsAtPath:path isDirectory:&isDir] && isDir)) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (!([fileManager fileExistsAtPath:otherInfoPath isDirectory:&isDir] && isDir)) {
        [fileManager createDirectoryAtPath:otherInfoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return [NSString stringWithFormat:@"%@/%@", isInfo ? otherInfoPath : path, file];
}

- (NSString *)cacheRequestFileName:(NSString *)requestUrl {
    return [requestUrl md5];
}

- (NSString *)cacheRequestOtherInfoFileName:(NSString *)requestUrl {
    return [requestUrl md5];
}

- (NSCachedURLResponse *)dataFromRequest:(NSURLRequest *)request {
    NSString *url = request.URL.absoluteString;
    NSString *fileName = [self cacheRequestFileName:url];
    NSString *otherInfoFileName = [self cacheRequestOtherInfoFileName:url];
    NSString *filePath = [self cacheFilePath:fileName withIsOtherInfo:NO];
    NSString *otherInfoPath = [self cacheFilePath:otherInfoFileName withIsOtherInfo:YES];
    NSDate *date = [NSDate date];

    if (![Reachability networkAvailable]) {//如果没有网络的情况下，就走缓存
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            BOOL expire = false;
            NSMutableDictionary *otherInfo = [NSMutableDictionary dictionaryWithContentsOfFile:otherInfoPath];
            if (self.cacheTime > 0) {
                NSInteger createTime = [[otherInfo objectForKey:@"time"] intValue];//上次访问的时间
                if (createTime + self.cacheTime < [date timeIntervalSince1970]) {
                    expire = true;
                }
            }
            
            if (expire == false) {
                
                NSData *data = [NSData dataWithContentsOfFile:filePath];
                NSURLResponse *response = [[NSURLResponse alloc] initWithURL:request.URL
                                                                    MIMEType:[otherInfo objectForKey:@"MIMEType"]
                                                       expectedContentLength:data.length
                                                            textEncodingName:[otherInfo objectForKey:@"textEncodingName"]];
                NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
                NSLog(@"data from cache ...MIMEType:%@",response.MIMEType);
                
                [otherInfo setObject:[NSString stringWithFormat:@"%f", [date timeIntervalSince1970]] forKey:@"time"];
                [otherInfo writeToFile:otherInfoPath atomically:YES];
                return cachedResponse;
            } else {
                NSLog(@"cache expire ... ");
                [fileManager removeItemAtPath:filePath error:nil];
                [fileManager removeItemAtPath:otherInfoPath error:nil];
            }
            
        }

        return nil;
    }
    __block NSCachedURLResponse *cachedResponse = nil;
    //sendSynchronousRequest请求也要经过NSURLCache
    id boolExsite = [self.responseDictionary objectForKey:url];
    if (boolExsite == nil) {
        [self.responseDictionary setValue:[NSNumber numberWithBool:TRUE] forKey:url];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data,NSError *error)
         {
             if (response && data) {
                 
                 [self.responseDictionary removeObjectForKey:url];
                 
                 if (error) {
                     NSLog(@"error : %@", error);
                     NSLog(@"not cached: %@", request.URL.absoluteString);
                     cachedResponse = nil;
                 }
//                 NSLog(@"webView已经缓存 ==MIMEType:%@ \n",response.MIMEType);
                 
                 //save to cache
                 NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]], @"time",
                                       response.MIMEType, @"MIMEType",
                                       response.textEncodingName, @"textEncodingName",
                                       nil];
                 [dict writeToFile:otherInfoPath atomically:YES];
                 [data writeToFile:filePath atomically:YES];

                 cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
             }
             
         }];
        
        return cachedResponse;
        //NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
    }
    return nil;
}


- (void)clearWebMemoryCache
{
    CIWURLCache *urlCache = (CIWURLCache *)[NSURLCache sharedURLCache];
    [urlCache removeAllCachedResponses];
    
}

- (void)cleanWebDiskCache
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", self.diskPath, [self cacheFolder]];
    
    if (CIWPathIsHaved(path)){//过滤缓存过期的文件
        NSFileManager * fileManager = [NSFileManager defaultManager];
        //获取缓存信息列表
        NSString *infoListPath = [NSString stringWithFormat:@"%@/OtherInfo",path];
        NSArray * tempFileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:infoListPath error:nil]];
        for(NSString *filedName in tempFileList){
            NSString *otherInfoPath = [NSString stringWithFormat:@"%@/%@",infoListPath,filedName];
            NSString *filedPath = [NSString stringWithFormat:@"%@/%@",path,filedName];
            NSDictionary *otherInfo = [NSDictionary dictionaryWithContentsOfFile:otherInfoPath];
            if(otherInfo && self.cacheTime){
                NSInteger expireTime = [[otherInfo objectForKey:@"time"] integerValue] + self.cacheTime;
                if(expireTime < [[NSDate date] timeIntervalSince1970]){
                    //如果已经过期，删除本地文件
                    [fileManager removeItemAtPath:otherInfoPath error:nil];
                    [fileManager removeItemAtPath:filedPath error:nil];
//                    NSLog(@"cache expire and delete ... ");
                }
            }
        }
    }
    
    //如果缓存内容超过最大限制，将清除所有webview所有的缓存内容
    if(self.diskCapacity < CIWGetSize(path)){
        [self deleteCacheFolder];
    }
    
}


@end
