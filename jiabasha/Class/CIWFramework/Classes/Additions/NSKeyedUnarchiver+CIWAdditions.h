//
//  NSKeyedUnarchiver+CIWAdditions.h
//  HunBaSha
//
//  Created by GarrettGao on 16/8/5.
//  Copyright © 2016年 hunbohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSKeyedUnarchiver (CIWAdditions)

+ (id)unarchiveObjectWithData_tryCatch:(NSData *)data;

+ (id)unarchiveObjectWithFile_tryCatch:(NSString *)path;
@end
