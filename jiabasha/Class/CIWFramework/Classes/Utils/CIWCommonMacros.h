//
//  CIWCommonMacros.h
//  HunBaSha
//

#ifndef HunBaSha_CIWCommonMacros_h
#define HunBaSha_CIWCommonMacros_h

////////////////////////////////////////////////////////////////////////////////
#pragma mark - shortcuts

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define DATA_ENV [DataEnvironment sharedDataEnvironment]

#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

#define ImageWithContentsOfFile(_imageName) [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], _imageName]];

////////////////////////////////////////////////////////////////////////////////
#pragma mark - common functions

//#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }


////////////////////////////////////////////////////////////////////////////////
#pragma mark - degrees/radian functions

#define degreesToRadian(x) (M_PI * (x) / 180.0)

#define radianToDegrees(radian) (radian*180.0)/(M_PI)

////////////////////////////////////////////////////////////////////////////////
#pragma mark - color functions

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#endif
