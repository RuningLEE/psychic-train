
//CIWObjectSingleton.h

/// This macro implements the various methods needed to make a safe singleton.
/// Sample usage:
///
/// CIWOBJECT_SINGLETON_BOILERPLATE(SomeUsefulManager, sharedSomeUsefulManager)
/// (with no trailing semicolon)
///

#ifndef CIW_OBJECT_SINGLETON_INCLUDE_FLAG
#define CIW_OBJECT_SINGLETON_INCLUDE_FLAG 1

#if __has_feature(objc_arc)
//compiling with ARC
#define CIWOBJECT_SINGLETON_BOILERPLATE(_object_name_, _shared_obj_name_) \
static _object_name_ *_instance;\
\
+(id)allocWithZone:(struct _NSZone *)zone{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
}\
\
+(_object_name_ *)_shared_obj_name_{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [[_object_name_ alloc] init];\
    });\
    return _instance;\
}\
\
-(id)copyWithZone:(NSZone *)zone{\
    return _instance;\
}\


#else
// compiling without ARC

#define CIWOBJECT_SINGLETON_BOILERPLATE(_object_name_, _shared_obj_name_) \
static _object_name_ *z##_shared_obj_name_ = nil;  \
+ (_object_name_ *)_shared_obj_name_ {             \
@synchronized(self) {                            \
if (z##_shared_obj_name_ == nil) {             \
/* Note that 'self' may not be the same as _object_name_ */                               \
/* first assignment done in allocWithZone but we must reassign in case init fails */      \
z##_shared_obj_name_ = [[self alloc] init];                                               \
CIWAssert((z##_shared_obj_name_ != nil), @"didn't catch singleton allocation");       \
}                                              \
}                                                \
return z##_shared_obj_name_;                     \
}                                                  \
+ (id)allocWithZone:(NSZone *)zone {               \
@synchronized(self) {                            \
if (z##_shared_obj_name_ == nil) {             \
z##_shared_obj_name_ = [super allocWithZone:zone]; \
return z##_shared_obj_name_;                 \
}                                              \
}                                                \
\
/* We can't return the shared instance, because it's been init'd */     \
CIWAssert(NO, @"use the singleton API, not alloc+init");        \
return nil;                                    \
}                                                  \
- (id)retain {                                     \
return self;                                   \
}                                                  \
- (NSUInteger)retainCount {                        \
return NSUIntegerMax;                          \
}                                                  \
- (oneway void)release {                                  \
}                                                  \
- (id)autorelease {                                \
return self;                                   \
}                                                  \
- (id)copyWithZone:(NSZone *)zone {                \
return self;                                   \
}



#endif



#endif
