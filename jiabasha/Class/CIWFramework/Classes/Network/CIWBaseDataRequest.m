//
//  CIWBaseDataRequest.m
//

#import "CIWBaseDataRequest.h"
#import "DataCacheManager.h"
#import "CIWDataRequestManager.h"
#import "CIWMaskActivityView.h"

@implementation CIWBaseDataRequest

#pragma mark - init methods using delegate

+ (void)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate{
    CIWBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:nil
                                                       withIndicatorView:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:YES
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[CIWDataRequestManager sharedManager] addRequest:request];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate{
	CIWBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:nil 
                                                       withIndicatorView:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[CIWDataRequestManager sharedManager] addRequest:request];
//    [request release];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withCancelSubject:(NSString*)cancelSubject{
	CIWBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:nil 
                                                       withIndicatorView:nil 
                                                       withCancelSubject:cancelSubject 
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[CIWDataRequestManager sharedManager] addRequest:request];
}
+ (void)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate 
                   withParameters:(NSDictionary*)params{
    CIWBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                          withParameters:params
                                                       withIndicatorView:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:YES
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[CIWDataRequestManager sharedManager] addRequest:request];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params{
	CIWBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:params 
                                                       withIndicatorView:nil 
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[CIWDataRequestManager sharedManager] addRequest:request];
//    [request release];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
               withCacheKey:(NSString*)cache
              withCacheType:(DataCacheManagerCacheType)cacheType{
    
	CIWBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:params 
                                                       withIndicatorView:nil 
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:cache
                                                           withCacheType:cacheType
                                                            withFilePath:nil];
    [[CIWDataRequestManager sharedManager] addRequest:request];
}

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withCancelSubject:(NSString*)cancelSubject{
	CIWBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:params 
                                                       withIndicatorView:nil 
                                                       withCancelSubject:cancelSubject 
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[CIWDataRequestManager sharedManager] addRequest:request];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject{
	CIWBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:nil 
                                                       withIndicatorView:indiView 
                                                       withCancelSubject:cancelSubject 
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[CIWDataRequestManager sharedManager] addRequest:request];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withIndicatorView:(UIView*)indiView{
	CIWBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:nil 
                                                       withIndicatorView:indiView
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[CIWDataRequestManager sharedManager] addRequest:request];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView{
	CIWBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:params 
                                                       withIndicatorView:indiView
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[CIWDataRequestManager sharedManager] addRequest:request];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
               withCacheKey:(NSString*)cache
              withCacheType:(DataCacheManagerCacheType)cacheType{
	CIWBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:params 
                                                       withIndicatorView:indiView
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:cache
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[CIWDataRequestManager sharedManager] addRequest:request];
}
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject{
	CIWBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:params 
                                                       withIndicatorView:indiView 
                                                       withCancelSubject:cancelSubject 
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[CIWDataRequestManager sharedManager] addRequest:request];
}

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cacheKey
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath{
    
	return [self initWithDelegate:delegate 
                   withRequestUrl:nil
                   withParameters:params 
                withIndicatorView:indiView 
                withCancelSubject:cancelSubject 
                  withSilentAlert:silent 
                     withCacheKey:cacheKey 
                    withCacheType:cacheType
                     withFilePath:localFilePath];
}

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withRequestUrl:(NSString*)url
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath{
    
    self = [super init];
	if(self) {
        _requestUrl = url;
        if (!_requestUrl) {
            _requestUrl = [self getRequestUrl];
        }
		_indicatorView = indiView;
		_isLoading = NO;
		_delegate = delegate;
		_resultDic = nil;
        _result = nil;
        _useSilentAlert = silent;
        _cacheKey = cache;
        if (_cacheKey && [_cacheKey length] > 0) {
            _usingCacheData = YES;
        }
        _cacheType = cacheType;
        if (cancelSubject && cancelSubject.length > 0) {
            _cancelSubject = cancelSubject;
        }
        
        if (_cancelSubject && _cancelSubject) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequest) name:_cancelSubject object:nil];
        }
        
        _totalData = NSIntegerMax;
        _downloadedData = 0;
        _currentProgress = 0;
        _requestStartTime = [NSDate date];
        _parameters = params;
        BOOL useCurrentCache = NO;
        if (localFilePath) {
            _filePath = localFilePath;
        }
        
        NSObject *cacheData = [[DataCacheManager sharedManager] getCachedObjectByKey:_cacheKey];
        if (cacheData) {
            useCurrentCache = [self onReceivedCacheData:cacheData];
        }
        
        if (!useCurrentCache) {
            _usingCacheData = NO;
            [self doRequestWithParams:params];
        }else{
            _usingCacheData = YES;
            [self performSelector:@selector(doRelease) withObject:nil afterDelay:0.1f];
        }
        
	}
	return self;
}


- (id)init {
    self = [super init];
    if(self) {
        _isLoading = NO;
        _resultDic = nil;
        _result = nil;
        _useSilentAlert = NO;
        _usingCacheData = NO;
        _totalData = NSIntegerMax;
        _downloadedData = 0;
        _currentProgress = 0;
        _requestStartTime = [NSDate date];
        _usingCacheData = NO;
        
    }
    return self;
}

- (void)cancelRequest {

}

#pragma mark - init methods using delegate

+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock{
    
	CIWBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                         withIndicatorView:indiView
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                           withIsCacheData:NO
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                           withIsUsingEtag:NO
                                                              withFilePath:nil
                                                            onRequestStart:nil
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:nil
                                                           onRequestFailed:nil
                                                         onProgressChanged:nil];
    [[CIWDataRequestManager sharedManager] addRequest:request];
}

+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock{
    
    CIWBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                         withIndicatorView:indiView
                                                         withCancelSubject:nil
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                           withIsCacheData:NO
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                           withIsUsingEtag:NO
                                                              withFilePath:nil
                                                            onRequestStart:onStartBlock
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:onCanceledBlock
                                                           onRequestFailed:onFailedBlock
                                                         onProgressChanged:nil];
    
    [[CIWDataRequestManager sharedManager] addRequest:request];
    
}

+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock{
    
	CIWBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                         withIndicatorView:indiView
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                           withIsCacheData:NO
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                           withIsUsingEtag:NO
                                                              withFilePath:nil
                                                            onRequestStart:onStartBlock
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:onCanceledBlock
                                                           onRequestFailed:onFailedBlock
                                                         onProgressChanged:nil];
    
    [[CIWDataRequestManager sharedManager] addRequest:request];

}

+ (void)requestWithParameters:(NSDictionary*)params
                withCacheType:(DataCacheManagerCacheType)cacheType
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock{
    
	CIWBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                         withIndicatorView:indiView
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                           withIsCacheData:YES
                                                             withCacheType:cacheType
                                                           withIsUsingEtag:NO
                                                              withFilePath:nil
                                                            onRequestStart:onStartBlock
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:onCanceledBlock
                                                           onRequestFailed:onFailedBlock
                                                         onProgressChanged:nil];
    
    [[CIWDataRequestManager sharedManager] addRequest:request];

}


#pragma mark 添加唯一标识   区分请求
+ (void)requestWithParameters:(NSDictionary*)params
               withRequestTag:(NSInteger)tag
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock{
    
	CIWBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                         withIndicatorView:indiView
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                           withIsCacheData:YES
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                           withIsUsingEtag:NO
                                                              withFilePath:nil
                                                            onRequestStart:onStartBlock
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:onCanceledBlock
                                                           onRequestFailed:onFailedBlock
                                                         onProgressChanged:nil];
    request.tag = tag;
    [[CIWDataRequestManager sharedManager] addRequest:request];
}

#pragma mark 添加唯一标识   区分请求   是否缓存
+ (void)requestWithParameters:(NSDictionary*)params
               withRequestTag:(NSInteger)tag
              withIsCacheData:(BOOL)isCache
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock{
    
	CIWBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                         withIndicatorView:indiView
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                           withIsCacheData:isCache
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                           withIsUsingEtag:NO
                                                              withFilePath:nil
                                                            onRequestStart:onStartBlock
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:onCanceledBlock
                                                           onRequestFailed:onFailedBlock
                                                         onProgressChanged:nil];
    request.isCache = isCache;
    request.tag = tag;
    [[CIWDataRequestManager sharedManager] addRequest:request];
}

#pragma mark 是否缓存
+ (void)requestWithParameters:(NSDictionary*)params
              withIsCacheData:(BOOL)isCache
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock{
    
	CIWBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                         withIndicatorView:indiView
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                           withIsCacheData:isCache
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                           withIsUsingEtag:NO
                                                              withFilePath:nil
                                                            onRequestStart:onStartBlock
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:onCanceledBlock
                                                           onRequestFailed:onFailedBlock
                                                         onProgressChanged:nil];
    [[CIWDataRequestManager sharedManager] addRequest:request];
}

//是否使用etag缓存策略
+ (void)requestWithParameters:(NSDictionary*)params
               withIsUsingEtag:(BOOL)isUsingEtag
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock
{
    
    CIWBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                         withIndicatorView:indiView
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                           withIsCacheData:YES
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                           withIsUsingEtag:isUsingEtag
                                                              withFilePath:nil
                                                            onRequestStart:onStartBlock
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:onCanceledBlock
                                                           onRequestFailed:onFailedBlock
                                                         onProgressChanged:nil];
    [[CIWDataRequestManager sharedManager] addRequest:request];
}

/**是否使用etag 和 缓存*/
+ (void)requestWithParameters:(NSDictionary*)params
              withIsCacheData:(BOOL)isCache
              withIsUsingEtag:(BOOL)isUsingEtag
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock
{
    CIWBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                         withIndicatorView:indiView
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                           withIsCacheData:isCache
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                           withIsUsingEtag:isUsingEtag
                                                              withFilePath:nil
                                                            onRequestStart:onStartBlock
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:onCanceledBlock
                                                           onRequestFailed:onFailedBlock
                                                         onProgressChanged:nil];
    [[CIWDataRequestManager sharedManager] addRequest:request];
    
}


- (id)initWithParameters:(NSDictionary*)params
          withRequestUrl:(NSString*)url
       withIndicatorView:(UIView*)indiView
       withCancelSubject:(NSString*)cancelSubject
         withSilentAlert:(BOOL)silent
            withCacheKey:(NSString*)cache
         withIsCacheData:(BOOL)isCahce
           withCacheType:(DataCacheManagerCacheType)cacheType
         withIsUsingEtag:(BOOL)isUsingEtag
            withFilePath:(NSString*)localFilePath
          onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
       onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
       onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
         onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock
       onProgressChanged:(void(^)(CIWBaseDataRequest *request,float progress))onProgressChangedBlock{
    
    self = [super init];
	if(self) {
        self.isAlertNetError = YES;//默认时候提示网络不稳定
        self.isCache = isCahce;
        self.isUsingEtag = isUsingEtag;
        _requestUrl = url;
        if (!_requestUrl) {
            _requestUrl = [self getRequestUrl];
        }
		_indicatorView = indiView;
		_isLoading = NO;
		_resultDic = nil;
        _result = nil;
        _useSilentAlert = silent;
        _cacheKey = cache;
        if (_cacheKey && [_cacheKey length] > 0) {
            _usingCacheData = YES;
        }
        _cacheType = cacheType;
        if (cancelSubject && cancelSubject.length > 0) {
            _cancelSubject = cancelSubject;
        }
        
        if (_cancelSubject && _cancelSubject.length > 0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequest) name:_cancelSubject object:nil];
        }
        if (onStartBlock) {
            _onRequestStartBlock = [onStartBlock copy];
        }
        if (onFinishedBlock) {
            _onRequestFinishBlock = [onFinishedBlock copy];
        }
        if (onCanceledBlock) {
            _onRequestCanceled = [onCanceledBlock copy];
        }
        if (onFailedBlock) {
            _onRequestFailedBlock = [onFailedBlock copy];
        }
        if (onProgressChangedBlock) {
            _onRequestProgressChangedBlock = [onProgressChangedBlock copy];
        }
        if (localFilePath) {
            _filePath = localFilePath;
        }
        
        _requestStartTime = [NSDate date];
        _parameters = params;
        BOOL useCurrentCache = NO;
        
        NSObject *cacheData = [[DataCacheManager sharedManager] getCachedObjectByKey:_cacheKey];
        if (cacheData) {
            useCurrentCache = [self onReceivedCacheData:cacheData];
        }
        
        if (!useCurrentCache) {
            _usingCacheData = NO;
            [self doRequestWithParams:params];
//            CIWDINFO(@"request %@ is created", [self class]);
        }else{
            _usingCacheData = YES;
            [self performSelector:@selector(doRelease) withObject:nil afterDelay:0.1f];
        }
	}
	return self;
}

#pragma mark - file download related init methods 
+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath{
    
	CIWBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate 
                                                          withParameters:params 
                                                       withIndicatorView:indiView 
                                                       withCancelSubject:cancelSubject 
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:localFilePath];
    
    [[CIWDataRequestManager sharedManager] addRequest:request];
}

+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
                 withFilePath:(NSString*)localFilePath
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onProgressChanged:(void(^)(CIWBaseDataRequest *request,float))onProgressChangedBlock{
    
	CIWBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                         withIndicatorView:indiView
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                           withIsCacheData:NO
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                           withIsUsingEtag:NO
                                                              withFilePath:localFilePath
                                                            onRequestStart:nil
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:nil
                                                           onRequestFailed:nil
                                                         onProgressChanged:onProgressChangedBlock];
    [[CIWDataRequestManager sharedManager] addRequest:request];
}
#pragma mark - life cycle methods 

- (void)doRelease{
    //remove self from Request Manager to release self;
    [[CIWDataRequestManager sharedManager] removeRequest:self];
}
- (void)dealloc {	
    if (_indicatorView) {
        //make sure indicator is closed
        [self showIndicator:NO];
    }
    if (_cancelSubject && _cancelSubject) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:_cancelSubject
                                                      object:nil];
    }
    
    _requestStartTime = nil;
    _filePath = nil;
    _delegate = nil;
    _requestUrl = nil;
    _cacheKey = nil;
    _result = nil;
    _cancelSubject = nil;
    _resultDic = nil;
    _resultString = nil;
    _indicatorView = nil;
    _parameters = nil;
    _onRequestStartBlock = nil;
    _onRequestFinishBlock = nil;
    _onRequestCanceled = nil;
    _onRequestFailedBlock = nil;
    _onRequestProgressChangedBlock = nil;
}

#pragma mark - util methods

//+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse{
//	NSData *jsonData = [cachedResponse dataUsingEncoding:NSUTF8StringEncoding];
//	return [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:nil];
//}


- (BOOL)onReceivedCacheData:(NSObject*)cacheData{
    // handle cache data in subclass
    // return yes to finish request, return no to continue request from server
    return NO;
}

- (void)processResult{
    NSString *codeString = [NSString stringWithFormat:@"%@",[self.resultDic objectForKey:@"result"]];
    NSString *message = [NSString stringWithFormat:@"%@",[self.resultDic objectForKey:@"error_msg"]];
//    CIWDINFO(@"failt dictionary message:%@",[self.resultDic objectForKey:@"error_msg"]);
    _result = [[CIWRequestResult alloc] initWithCode:codeString withMessage:message];
//    if (![_result isSuccess])
//        CIWDERROR(@"request[%@] failed with message %@",self,_result.code);
//    else
//        CIWDINFO(@"request[%@] :%@" ,self ,@"success");
}


- (BOOL)isSuccess{
    if (_result && [_result isSuccess]) {
        return YES;
    }
    return NO;
}

- (NSString*)encodeURL:(NSString *)string{
    
    if(![string isKindOfClass:[NSString class]]){
        string = [NSString stringWithFormat:@"%@",string];
    }
    
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString) {
        return newString;
    }

	return @"";
}

- (void)showIndicator:(BOOL)bshow{
	_isLoading = bshow;
    if (bshow) {
        if (!_maskActivityView) {
            _maskActivityView = [CIWMaskActivityView loadFromXib];
            [_maskActivityView showInView:_indicatorView];
        }
    }else {
        if (_maskActivityView) {
            [_maskActivityView hide];
        }
    }
}



- (BOOL)handleResultObject:(id)responseObject{

    if(![responseObject isKindOfClass:[NSDictionary class]]){
        return NO;
    }
    NSDictionary *results = responseObject;
	if (!results) {
		CIWDERROR(@"!empty response error with Request:%@",[self class]);
        
        if (_onRequestFailedBlock) {
            _onRequestFailedBlock(self,[NSError errorWithDomain:NSURLErrorDomain
                                                           code:0
                                                       userInfo:nil]);
        }

		return NO;
	}
    
	if(!results) {
        if (_delegate) {
            //using delegate
            if([_delegate respondsToSelector:@selector(request:didFailLoadWithError:)]){
                [_delegate request:self 
              didFailLoadWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                       code:0
                                                   userInfo:nil]];
            }
        }else {
            //using block callback
            if (_onRequestFailedBlock) {
                _onRequestFailedBlock(self,[NSError errorWithDomain:NSURLErrorDomain
                                                               code:0
                                                           userInfo:nil]);
            }
        }
        return NO;
	}else{
        _resultDic = [[NSMutableDictionary alloc] initWithDictionary:results];
        self.errCode = [_resultDic objectForKey:@"err"];
        
        [self processResult];
        if ([self.result isSuccess] && _cacheKey) {
            if (_cacheType == DataCacheManagerCacheTypeMemory) {
                [[DataCacheManager sharedManager] addObjectToMemory:self.resultDic forKey:_cacheKey];
            }else{
                [[DataCacheManager sharedManager] addObject:self.resultDic forKey:_cacheKey];
            }
        }
        
        if (_delegate) {
            if([_delegate respondsToSelector:@selector(requestDidFinishLoad:)]){
                [_delegate requestDidFinishLoad:self];
            }
        }else {
            if (_onRequestFinishBlock) {
                _onRequestFinishBlock(self);
            }
        }
        return YES;
    }
    return NO;
}
#pragma mark - hook methods
- (void)doRequestWithParams:(NSDictionary*)params{
    CIWDERROR(@"should implement request logic here!");
}
- (NSStringEncoding)getResponseEncoding{
    return NSUTF8StringEncoding;
    //return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
}

- (NSDictionary*)getStaticParams{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

	return parameters;
}

- (CIWRequestMethod)getRequestMethod{
	return CIWRequestMethodGet;
}

- (NSString*)getRequestUrl{
	return @"";
}

- (NSString*)getRequestHost{
	return DATA_ENV.urlRequestHost;
}

@end
