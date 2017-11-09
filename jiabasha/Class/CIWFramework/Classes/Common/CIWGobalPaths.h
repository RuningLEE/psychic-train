//
//  CIWFrameWork
//
//  Created by GarrettGao on 14/5/6.
//  Copyright (c) 2014年 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 设置全局bundle,默认为main bundle, 如多主题可以使用
 */
void CIWSetDefaultBundle(NSBundle* bundle);

/**
 * 返回全局默认bundle
 */
NSBundle *CIWGetDefaultBundle();

/**
 * 返回bundle资源路径
 */
NSString *CIWPathForBundleResource(NSString* relativePath);

/**
 * 返回Documents资源路径
 */
NSString *CIWPathForDocumentsResource(NSString* relativePath);

/**
 * 返回Cache资源路径
 */
NSString *CIWPathForCacheResource(NSString* relativePath);

/**
 * 返回Library资源路径
 */
NSString *CIWPathForLibraryResource(NSString* relativePath);

/**
 *  判断目录是否存在
 */
BOOL CIWPathIsHaved(NSString* relativePath);

/**
 *  网络请求缓存路径(Cache子目录)
 */
NSString *CIWPathForReqeustDateCacheResource(NSString* fileName);

/**
 *  获取本地磁盘某个文件大小(单位B)
 */
NSUInteger CIWGetSize(NSString* diskPath);

