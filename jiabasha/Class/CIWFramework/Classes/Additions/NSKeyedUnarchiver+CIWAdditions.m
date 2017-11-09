//
//  NSKeyedUnarchiver+CIWAdditions.m
//  HunBaSha
//
//  Created by GarrettGao on 16/8/5.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import "NSKeyedUnarchiver+CIWAdditions.h"

@implementation NSKeyedUnarchiver (CIWAdditions)

+ (id)unarchiveObjectWithData_tryCatch:(NSData *)data{
    if(data == nil || data == NULL){
        return nil;
    }
    @try {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }@catch (NSException *exception) {
        return nil;
    }
}


+ (id)unarchiveObjectWithFile_tryCatch:(NSString *)path{
    if(path == nil || path == NULL){
        return nil;
    }
    @try {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }@catch (NSException *exception) {
        return nil;
    }
}
@end
