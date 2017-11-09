
//
//  BaseRequest.m
//  weddingBusiness
//
//  Created by GarrettGao on 15/1/20.
//  Copyright (c) 2015年 HunBoHui. All rights reserved.
//

#import "BaseRequest.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import "BaseRequest.h"
#import "GTMBase64.h"
#import "base64.h"
#import "CommonUtils.h"

@implementation BaseRequest


- (NSString *)getRequestUrl{
//        if ([[self getURI] isEqualToString:@"/common/upload/image"]) {
//            return @"http://192.168.1.25:8080/api/common/upload/image";
//        }
    return [NSString stringWithFormat:@"%@%@?",DATA_ENV.requestHost, [self getURI]];
}

- (void)doRequestWithParams:(NSDictionary *)params{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (params) {
        [parameters addEntriesFromDictionary:params];
    }
    [parameters addEntriesFromDictionary:[self getDefaultParameters]];
    [parameters setObject:[self getAppUsignWithParamters:parameters] forKey:@"app_usign"];
    
    [super doRequestWithParams:parameters];
    
}

- (void)uploadRequestWithParams:(NSDictionary*)params {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (params) {
        [parameters addEntriesFromDictionary:params];
    }
    [parameters addEntriesFromDictionary:[self getDefaultParameters]];
    [parameters setObject:[self getAppUsignWithParamters:parameters] forKey:@"app_usign"];
    
    [super uploadRequestWithParams:parameters];
}

- (NSDictionary *)getDefaultParameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:APP_ID forKey:@"app_id"];
    
    NSString *timeInterval = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
    [params setObject:timeInterval forKey:@"client_timestamp"];
    
    [params setObject:APP_VERSION forKey:@"client_version"];

    if ([CommonUtils isEmpty:DATA_ENV.city.cityId]) {
        [params setObject:@"110900" forKey:@"city_id"];//默认北京
    } else {
        [params setValue:DATA_ENV.city.cityId forKey:@"city_id"];
    }
    
    if (DATA_ENV.client.clientId) {
        [params setValue:DATA_ENV.client.clientId forKey:@"client_guid"];
    }else{
        [params setObject:APP_ID forKey:@"client_guid"];
    }
    
//    if ([[self getRequestUrl] containsString:@"/common/upload/image"]) {
//        [params setValue:@"979722892" forKey:@"client_guid"];
//        [params setValue:@"10013" forKey:@"app_id"];
//        [params setValue:@"1.0.0" forKey:@"client_version"];
//    }

    if (DATA_ENV.isLogin) {
        [params setValue:DATA_ENV.userInfo.token forKey:@"access_token"];
    }
    
    return params;
}

//长度大于3 并且r[a-z]_开头或者_s[a-z]结尾 或后面有多个 [.*?] 过滤掉；
- (BOOL)deleteKey:(NSString *)key{
    if ([key length] <= 3) {
        return NO;
    }
    if ([key isEqualToString:@"upload"]) {
        return YES;
    }
    NSString *regex = @"r[a-z]_[a-zA-Z0-9_]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isDelete = [predicate evaluateWithObject:key];
    if (!isDelete) {
        regex = @"[a-zA-Z0-9_]+_s[a-z](\\[.*?\\])*";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        isDelete = [predicate evaluateWithObject:key];
    }
    return isDelete;
}

- (NSString *)getAppUsignWithParamters:(NSDictionary *)parameters{
    NSString *uri = [self encodeURL:[self getURI]];
    NSArray *allKeys = [parameters allKeys];
    NSMutableArray *keys = [NSMutableArray arrayWithArray:allKeys];
    for (NSString *key in allKeys) {
        if ([self deleteKey:key]) {
            [keys removeObject:key];
        }
    }
    NSArray *sorts = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
        return [key1 caseInsensitiveCompare:key2];
    }];
    NSMutableString *sortString = [NSMutableString string];
    for (int i=0; i<[sorts count]; i++) {
        NSString *key = [sorts objectAtIndex:i];
        NSString *value = [parameters objectForKey:key];
        [sortString appendFormat:@"%@=%@",key,value];
        if (i < [sorts count]-1) {
            [sortString appendString:@"&"];
        }
    }
    NSString *paras = [self encodeURL:sortString];
    NSString *requestMethod = [self getRequestMethod] == CIWRequestMethodGet? @"GET": @"POST";
    NSString *value = [NSString stringWithFormat:@"%@&%@&%@",requestMethod, uri, paras];
    NSString *key = [NSString stringWithFormat:@"%@&",APP_KEY];
    NSString *usign = [self hmacsha1:value key:key];
    return usign;
}

- (NSString *)getURI{
    return @"";
}

- (NSString *)getRequestHost{
    return DATA_ENV.requestHost;
}

- (NSDictionary *)getStaticParams{
    return nil;
}

- (NSString *)hmacsha1:(NSString *)text key:(NSString *)key{
    NSData *secretData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[20];
    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(result, 20, base64Result, &theResultLength, YES);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
    return base64EncodedResult;
}

+ (NSString *)getDefaultRequstName
{
    return NSStringFromClass([self class]);
}


@end
