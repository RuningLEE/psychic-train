//
//  CIWUncatchingException.h
//  CIWFrameWork
//
//  Created by GarrettGao on 15/3/25.
//  Copyright (c) 2015年 HunBoHui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIWUncatchingException : NSObject
{
    BOOL _dismissed;
}

@end

void HandleException(NSException *exception);
void SignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);

