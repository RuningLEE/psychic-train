//
//  CIWGobalPaths.m
//
//  Created by GarrettGao on 14/5/6.
//  Copyright (c) 2014年 MyCompany. All rights reserved.
//

static NSBundle* globalBundle = nil;

/**
 * 设置全局bundle,默认为main bundle, 如多主题可以使用
 */
void CIWSetDefaultBundle(NSBundle* bundle) {
    globalBundle = bundle;
}

/**
 * 返回全局默认bundle
 */
NSBundle *CIWGetDefaultBundle() {
    return (nil != globalBundle) ? globalBundle : [NSBundle mainBundle];
}

/**
 * 返回bundle资源路径
 */
NSString *CIWPathForBundleResource(NSString* relativePath) {
    NSString* resourcePath = [CIWGetDefaultBundle() resourcePath];
    return [resourcePath stringByAppendingPathComponent:relativePath];
}

/**
 * 返回Documents资源路径
 */
NSString *CIWPathForDocumentsResource(NSString* relativePath) {
    static NSString* documentsPath = nil;
    if (nil == documentsPath) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsPath = dirs[0];
    }
    return [documentsPath stringByAppendingPathComponent:relativePath];
}


/**
 * 返回Cache资源路径
 */
NSString *CIWPathForCacheResource(NSString* relativePath){
    static NSString* documentsPath = nil;
    if (nil == documentsPath) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        documentsPath = dirs[0];
    }
    return [documentsPath stringByAppendingPathComponent:relativePath];
}

/**
 * 返回Library资源路径
 */
NSString *CIWPathForLibraryResource(NSString* relativePath){
    static NSString* libraryPath = nil;
    if(nil == libraryPath){
        libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    }
    return [libraryPath stringByAppendingPathComponent:relativePath];
}

/**
 *  判断目录是否存在
 */
BOOL CIWPathIsHaved(NSString* relativePath){
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:relativePath];

}

/**
 *  网络请求缓存路径(Cache子目录),没有自动创建
 */
NSString *CIWPathForReqeustDateCacheResource(NSString* fileName){
    NSString *requestCachePath = CIWPathForCacheResource(@"RequestCacheData");
    if(!CIWPathIsHaved(requestCachePath)){
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:requestCachePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return [NSString stringWithFormat:@"%@/%@",requestCachePath,fileName];
}

/**
 *  获取本地磁盘某个文件大小(单位B)
 */
NSUInteger CIWGetSize(NSString* diskPath){
    __block NSUInteger size = 0;
    dispatch_queue_t ioQueue = dispatch_queue_create("com.hunbohui.urlcache", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskPath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [diskPath stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    return size;
}



