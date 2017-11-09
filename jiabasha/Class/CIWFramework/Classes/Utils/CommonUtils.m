//
//  CommonUtils.m
//  LingQ
//
//  Created by Rainbow on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommonUtils.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <mach/mach.h>
#import <mach/mach_host.h>

#define RANDOM_SEED() srandom((int)time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

@implementation CommonUtils

+ (NSString *)convertArrayToString:(NSArray *)array{
	NSMutableString *string = [NSMutableString stringWithCapacity:0];
	for( NSInteger i=0;i<[array count];i++ ){
		[string appendFormat:@"%@%@",(NSString *)array[i], (i<([array count]-1))?@",":@""];
	}
	return string;
}

+ (NSArray *)convertStringToArray:(NSString *)string{
	return [string componentsSeparatedByString:@","];
}

+ (BOOL)validateEmail:(NSString *)candidate{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL)validateCellPhone:(NSString *)candidate{
	NSString *phoneRegex = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)"; 
	NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex]; 
	return [phoneTest evaluateWithObject:candidate];
}
// 判断空字符串
+ (BOOL)isEmpty:(NSString *)string {
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    
    if ([string isKindOfClass:[NSString class]] && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    else {
        return NO;
    }
}


+ (long)getDocumentSize:(NSString *)folderName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
	documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat: @"/%@/", folderName]];
    //	NSDictionary *fileAttributes = [fileManager attributesOfFileSystemForPath:documentsDirectory error:nil];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:documentsDirectory error:nil];
    
    long size = 0;
	if(fileAttributes != nil)
	{
		NSNumber *fileSize = fileAttributes[NSFileSize];
        size = [fileSize longValue];
	}
    return size;
}

+ (NSArray *)getLetters
{
	return @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
}

+ (NSArray *)getUpperLetters
{
	return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
}
//因为担心ipv6的问题 苹果会拒绝，所以屏蔽掉
//+ (NSString *)getIPAddress
//{
//	NSString *address = @"Unknown";
//	struct ifaddrs *interfaces = NULL;
//	struct ifaddrs *temp_addr = NULL;
//	int success = 0;
//    
//	// retrieve the current interfaces - returns 0 on success
//	success = getifaddrs(&interfaces);
//	if (success == 0)
//	{
//		// Loop through linked list of interfaces
//		temp_addr = interfaces;
//		while(temp_addr != NULL)
//		{
//			if(temp_addr->ifa_addr->sa_family == AF_INET)
//			{
//				// Check if interface is en0 which is the wifi connection on the iPhone
//                //                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
//                //                NSLog(@"address: %@", [NSString stringWithUTF8String:temp_addr->ifa_name]);
//				if([@(temp_addr->ifa_name) isEqualToString:@"en0"])
//				{
//					// Get NSString from C String
//					address = @(inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr));
//				}
//			}
//            
//			temp_addr = temp_addr->ifa_next;
//		}
//	}
//    
//	// Free memory
//	freeifaddrs(interfaces);
//    
//	return address;
//    
//    //    char iphone_ip[255];
//    //    strcpy(iphone_ip,"127.0.0.1"); // if everything fails
//    //    NSHost* myhost =[NSHost currentHost];
//    //    if (myhost)
//    //    {
//    //        NSString *ad = [myhost address];
//    //        if (ad)
//    //            strcpy(iphone_ip,[ad cStringUsingEncoding: NSISOLatin1StringEncoding]);
//    //    }
//    //    return [NSString stringWithFormat:@"%s",iphone_ip];
//}

+ (NSString *)getFreeMemory{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);        
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
        NSLog(@"Failed to fetch vm statistics");
    
    /* Stats in bytes */ 
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * (int)pagesize;
    natural_t mem_free = vm_stat.free_count * (int)pagesize;
    //  natural_t mem_total = mem_used + mem_free;
    return [NSString stringWithFormat:@"%0.1f MB used/%0.1f MB free", mem_used/1048576.f, mem_free/1048576.f];
    //    NSLog(@"used: %u free: %u total: %u", mem_used, mem_free, mem_total);
}

+ (NSString *)getDiskUsed
{
    NSDictionary *fsAttr = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    float diskSize = [fsAttr[NSFileSystemSize] doubleValue] / 1073741824.f;
    float diskFreeSize = [fsAttr[NSFileSystemFreeSize] doubleValue] / 1073741824.f;
    float diskUsedSize = diskSize - diskFreeSize;
    return [NSString stringWithFormat:@"%0.1f GB of %0.1f GB", diskUsedSize, diskSize];
}

+ (NSString *)getStringValue:(id)value
{
    if ([value isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        if ([@"" isEqualToString:value]) {
            return nil;
        }
        return value;
    }
    else
    {
        return [value stringValue];
    }
}

+ (BOOL)createDirectorysAtPath:(NSString *)path{
    @synchronized(self){
        NSFileManager* manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:path]) {
            NSError *error = nil;
            if (![manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
                return NO;
            }
        }
    }
    return YES;
}

+ (NSString*)getDirectoryPathByFilePath:(NSString *)filepath{
    
    if(!filepath || [filepath length] == 0){
        return @"";
    }
    
    NSInteger pathLength = [filepath length];
    NSInteger fileLength = [[filepath lastPathComponent] length];
    return [filepath substringToIndex:(pathLength - fileLength - 1)];
}

// get index by random rate like this NSArray[NSNumber(10.0),NSNumber(30.0),NSNumber(40.0),NSNumber(20.0)]
+(int)getIndexByRandomRates:(NSArray*)rates{
    RANDOM_SEED();
    int maxValue = 0;
    for (NSNumber *rate in rates) {
        maxValue = maxValue + [rate intValue];
    }
    if (maxValue < 1) {
        maxValue = 1;
    }
    int rateValue = RANDOM_INT(1, maxValue);
    int startValue = 0;
    int endValue = 0;
    int resultIndex = -1;
    for (NSNumber *rate in rates) {
        resultIndex = resultIndex + 1;
        if ([rate intValue] == 0) {
            // skip when rate is 0
            continue;
        }
        endValue = startValue + [rate intValue];
        if (rateValue > startValue && rateValue <= endValue) {
            //this is the generated chip;
            return resultIndex;
        }
        startValue = endValue;
    }
    return resultIndex;
    
}
//NSUserDefaults
+ (id)getObjectFromUD:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (NSString *)getClientId{
    NSString *client_id = [CommonUtils getObjectFromUD:@"client_id"];
    return client_id;
}

+ (void)ObjectisNullorNill:(id)value andKey:(NSString *)key{
    
    id mutaValue = [value mutableCopy];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSArray *allkeys = [(NSMutableDictionary *)mutaValue allKeys];
        for (int i=0; i<[allkeys count]; i++) {
            NSString *key = [allkeys objectAtIndex:i];
            id value = [mutaValue objectForKey:key];
            
            [self ObjectisNullorNill:value andKey:key];
            
        }
    }else  {
        if ([CommonUtils isEmpty:value]) {
            [mutaValue setObject:@"" forKey:key];
        }
    }
    
}

+ (void)saveObjectToUD:(id)value key:(NSString *)key {
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutaDic = [value mutableCopy];
        NSArray *allkeys = mutaDic.allKeys;
        for (int i=0; i<[allkeys count]; i++) {
            NSString *key = [allkeys objectAtIndex:i];
            
            NSString *value = [mutaDic objectForKey:key];
            if ([CommonUtils isEmpty:value]) {
                [mutaDic setObject:@"" forKey:key];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:mutaDic forKey:key];
        
    } else if ([value isKindOfClass:[NSArray class]]){
        NSMutableArray * arr = [NSMutableArray array];
        for (NSDictionary * dic in value) {
            NSMutableDictionary *mutaDic = [dic mutableCopy];
            NSArray *allkeys = mutaDic.allKeys;
            for (int i=0; i<[allkeys count]; i++) {
                NSString *key = [allkeys objectAtIndex:i];
                
                NSString *value = [mutaDic objectForKey:key];
                if ([CommonUtils isEmpty:value]) {
                    [mutaDic setObject:@"" forKey:key];
                }
                
                
            }
            [arr addObject:dic];
            
        }
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:key];
    }else{
        if(![self isEmpty:value]){
            [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteObjectFromUD:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

/**
 * 参数：dmainName:域名
 */
+ (void)addLoginTokenToWebCookiesWithHostName:(NSString *)hostName
{
    if(DATA_ENV.isLogin){
        
        if(!hostName || !hostName.length){
            hostName = @"jiehun.com.cn";
        }
        NSString *userToken = [NSString stringWithFormat:@"%@",DATA_ENV.userInfo.token];
        
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSMutableDictionary *cookiePropertiesJhu = [NSMutableDictionary dictionary];
        [cookiePropertiesJhu setObject:@"jhu" forKey:NSHTTPCookieName];
        [cookiePropertiesJhu setObject:[userToken encode] forKey:NSHTTPCookieValue];
        [cookiePropertiesJhu setObject:[NSString stringWithFormat:@".%@",hostName] forKey:NSHTTPCookieDomain];
        [cookiePropertiesJhu setObject:hostName forKey:NSHTTPCookieOriginURL];
        [cookiePropertiesJhu setObject:@"/" forKey:NSHTTPCookiePath];
        [cookiePropertiesJhu setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookieJhu = [NSHTTPCookie cookieWithProperties:cookiePropertiesJhu];
        [cookieJar setCookie:cookieJhu];
    }else{
        [self cleanWebCookies];
    }
}

/**
 *  清理 WebView cookies
 */
+ (void)cleanWebCookies
{
    NSArray * cookArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie*cookie in cookArray) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

@end
