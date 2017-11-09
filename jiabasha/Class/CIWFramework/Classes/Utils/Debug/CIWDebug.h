//
//  CIWDEBUG.h
//
//  Modified from Three20 Debugging tools by lian jie on 5/31/10.

/**
 * Modified from Three20 Debugging tools.
 *
 * Provided in this header are a set of debugging tools. This is meant quite literally, in that
 * all of the macros below will only function when the DEBUG preprocessor macro is specified.
 *
 * TTDASSERT(<statement>);
 * If <statement> is false, the statement will be written to the log and if you are running in
 * the simulator with a debugger attached, the app will break on the assertion line.
 *
 * TTDPRINT(@"formatted log text %d", param1);
 * Print the given formatted text to the log.
 *
 * TTDPRINTMETHODNAME();
 * Print the current method to the log.
 *
 * TTDCONDITIONLOG(<statement>, @"formatted log text %d", param1);
 * Only if <statement> is true then the formatted text will be written to the log.
 *
 * TTDINFO/TTDWARNING/TTDERROR(@"formatted log text %d", param1);
 * Will only write the formatted text to the log if TTMAXLOGLEVEL is greater than the respective
 * TTD* method's log level. See below for log levels.
 *
 * The default maximum log level is TTLOGLEVEL_WARNING.
 */
#define CIWDEBUG
#define CIWLOGLEVEL_INFO     10
#define CIWLOGLEVEL_WARNING  3
#define CIWLOGLEVEL_ERROR    1

#ifndef CIWMAXLOGLEVEL

#ifdef DEBUG
    #define CIWMAXLOGLEVEL CIWLOGLEVEL_INFO
#else
    #define CIWMAXLOGLEVEL CIWLOGLEVEL_ERROR
#endif

#endif

// The general purpose logger. This ignores logging levels.
#ifdef CIWDEBUG
  #define CIWDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
  #define CIWDPRINT(xx, ...)  ((void)0)
#endif

// Prints the current method's name.
#define CIWDPRINTMETHODNAME() CIWDPRINT(@"%s", __PRETTY_FUNCTION__)

// Log-level based logging macros.
#if CIWLOGLEVEL_ERROR <= CIWMAXLOGLEVEL
  #define CIWDERROR(xx, ...)  CIWDPRINT(xx, ##__VA_ARGS__)
#else
  #define CIWDERROR(xx, ...)  ((void)0)
#endif

#if CIWLOGLEVEL_WARNING <= CIWMAXLOGLEVEL
  #define CIWDWARNING(xx, ...)  CIWDPRINT(xx, ##__VA_ARGS__)
#else
  #define CIWDWARNING(xx, ...)  ((void)0)
#endif

#if CIWLOGLEVEL_INFO <= CIWMAXLOGLEVEL
  #define CIWDINFO(xx, ...)  CIWDPRINT(xx, ##__VA_ARGS__)
#else
  #define CIWDINFO(xx, ...)  ((void)0)
#endif

#ifdef CIWDEBUG
  #define CIWDCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
                                                  CIWDPRINT(xx, ##__VA_ARGS__); \
                                                } \
                                              } ((void)0)
#else
  #define CIWDCONDITIONLOG(condition, xx, ...) ((void)0)
#endif


#define CIWAssert(condition, ...)                                       \
do {                                                                      \
    if (!(condition)) {                                                     \
        [[NSAssertionHandler currentHandler]                                  \
            handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
                                file:[NSString stringWithUTF8String:__FILE__]  \
                            lineNumber:__LINE__                                  \
                            description:__VA_ARGS__];                             \
    }                                                                       \
} while(0)
