//
//  CIWURLCache.h
//  CIWFrameWork
//
//  Created by GarrettGao on 15/7/1.
//  Copyright (c) 2015年 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIWURLCache : NSURLCache

@property (nonatomic, assign) NSInteger cacheTime;
@property (nonatomic, strong) NSString *diskPath;
@property (nonatomic, strong) NSMutableDictionary *responseDictionary;

- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path cacheTime:(NSInteger)cacheTime;


@end
