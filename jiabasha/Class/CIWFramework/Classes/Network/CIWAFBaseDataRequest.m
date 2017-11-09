//
//  CIWAFBaseDataRequest.m
//

#import "CIWAFBaseDataRequest.h"
#import "CIWGobalPaths.h"
#import "AFHTTPRequestOperationManager.h"
#import "CommonUtils.h"
#import "CIWNetworkTrafficManager.h"
#import "NSString+Extension.h"
#import "MessageView.h"
#import "AFHTTPRequestOperationManager.h"
#import "CIWDataRequestManager.h"


@class AllBrandDataRequest;

@interface CIWAFBaseDataRequest()

@property (strong, nonatomic) NSString *cacheUrl;

/**
 *  取消网络请求
 */
- (void)cancelRequest;

- (void)generateRequestWithUrl:(NSString*)url
                withParameters:(NSDictionary*)params;
@end

@implementation CIWAFBaseDataRequest
#pragma mark -
#pragma mark private method

+ (void)cancelRequestWithCancelSubject:(NSString *)cancelSubject
{
    [[NSNotificationCenter defaultCenter] postNotificationName:cancelSubject object:nil];
}

- (void)cancelRequest{
    
    [_requestOperation cancel];
    
    if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(requestDidCancelLoad:)]){
            [self.delegate requestDidCancelLoad:self];
        }
    }else {
        if (_onRequestCanceled) {
            _onRequestCanceled(self);
        }
    }
    
    CIWDINFO(@"cancelling request");
}

- (void)generateRequestWithUrl:(NSString*)url
                withParameters:(NSDictionary*)params{
    
    NSString *strPN = params[@"_pn"];
    if ([strPN intValue] != 0 && self.isCache) {
        self.isCache = NO;
    }

	// process params
	NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithCapacity:10];
	[allParams addEntriesFromDictionary: params];
	NSDictionary *staticParams = [self getStaticParams];
	if (staticParams != nil) {
		[allParams addEntriesFromDictionary:staticParams];
	}
    // used to monitor network traffic , this is not accurate number.
    
    
    NSString *valueStr = @"";//参数值
    
    /**发送网络请求*/
	if ([self getRequestMethod] == CIWRequestMethodGet){    //Get请求
        
        NSString *paramString = @"";
		if (allParams) {
			NSArray *allKeys = [allParams allKeys];
            allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
                return [key1 caseInsensitiveCompare:key2];
            }];
			NSInteger count = [allKeys count];
			NSString *value = nil;
			for (NSUInteger i=0; i<count; i++) {
				id key = allKeys[i];
				value = (NSString *)allParams[key];
                

				value = [self encodeURL:value];
                
                

				paramString = [paramString stringByAppendingString:(i == 0)?@"":@"&"];
				paramString = [paramString stringByAppendingFormat:@"%@=%@",key,value];
                
                if ((![key isEqualToString:@"client_timestamp"]) &&
                    (![key isEqualToString:@"app_usign"]) &&
                    (![key isEqualToString:@"access_token"]) &&
                    (![key isEqualToString:@"latlng"])
                    )
                {
                    
                    valueStr = [valueStr stringByAppendingString:(valueStr.length == 0)?@"":@"&"];
                    valueStr = [valueStr stringByAppendingFormat:@"%@=%@",key,value];
                }
			}
		}
        
        /**网络请求url*/
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",url,paramString];
        
        /**数据缓存的url*/
        self.cacheUrl = [NSString stringWithFormat:@"%@%@",url,valueStr];
        
        /**获取本地缓存数据*/
        NSDictionary *cacheResult = [self getRequestLocalCacheWithUrl:_cacheUrl];
        /**如果允许返回缓存数据，返回本地数据*/
        if (cacheResult &&
            self.isCache &&
            _cacheType != DataCacheManagerNoRetureData)
        {
            [self returnCacheData:cacheResult];
        }
        
        /**添加uri参数 etag */
        urlStr = [self appendingEtagUriWithCacheResult:cacheResult withOriginUrl:urlStr];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [self requestStarted:manager];
        NSLog(@"--------------RequstUrl-----------(GET)\n  %@\n\n",urlStr);

        _requestOperation = [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self requestFinished:operation withResponseObject:responseObject];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self requestFailed:operation withError:error];
            
        }];
        self.requestSerializer = manager.requestSerializer;
        
        
    }else if([self getRequestMethod] == CIWRequestMethodPost){  //Post 请求
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [self requestStarted:manager];
        
        NSLog(@"\n--------------RequstUrl-----------(POST)\n  %@\n   参数:\n%@\n\n",url,params);

        self.requestOperation = [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self requestFinished:operation withResponseObject:responseObject];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           
            [self requestFailed:operation withError:error];
            
        }];
    
        self.requestSerializer = manager.requestSerializer;
        
    }
    

    
    if (_filePath && [_filePath length] > 0) {//下载文件
        //create folder
        NSInteger pathLength = [_filePath length];
        NSInteger fileLength = [[_filePath lastPathComponent] length];
        NSString *directoryPath = [_filePath substringToIndex:(pathLength - fileLength - 1)];
        [CommonUtils createDirectorysAtPath:directoryPath];
    }

    [self setNetWorkConfig];
}

/**添加uri参数 etag */
- (NSString *)appendingEtagUriWithCacheResult:(NSDictionary *)cacheResult
                                withOriginUrl:(NSString *)url
{
    if(self.isUsingEtag &&
       cacheResult &&
       ([cacheResult isKindOfClass:[NSDictionary class]] ||[cacheResult isKindOfClass:[NSMutableDictionary class]]) &&
        ([self getRequestMethod] == CIWRequestMethodGet))
    {
        NSString *cacheTag = [cacheResult objectForKey:@"etag"];
        if(cacheTag) url = [NSString stringWithFormat:@"%@&%@=%@",url,@"_etag",cacheTag];
    }
    return url;
}

//获取本地数据
- (NSDictionary *)getRequestLocalCacheWithUrl:(NSString *)strUrl{
    if(!strUrl){
        return nil;
    }
    NSString *strNameMd5 = [strUrl md5];
    self.fileName = strNameMd5;
    
    NSString *filePath = CIWPathForReqeustDateCacheResource(strNameMd5); //缓存请求数据路径
    BOOL isHaveFile    = CIWPathIsHaved(filePath);       //判断本地是否有该缓存路径
    if (isHaveFile &&
        (self.isCache || self.isUsingEtag)
        && ([self getRequestMethod] == CIWRequestMethodGet))
    {//有缓存且开启缓存或者打开etag模式
        
        //先读取缓存数据，再去重新重新请求网络
        @try {
            NSDictionary *dicData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            return dicData;
        }
        @catch (NSException *exception) {
        }
    }
    return nil;
}

- (void)setNetWorkConfig
{
    //设置超时时间
    [_requestSerializer setTimeoutInterval:40];
}

- (NSString *)strContentWithStr:(NSString *)strText
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@",strText];
    return str;
}

#pragma mark 直接返回缓存数据
- (void)returnCacheData:(NSDictionary *)cacheData
{
    [self showIndicator:NO];
    self.isCachedData = YES;
	[self handleResultObject:cacheData];
    [self doRelease];
}
- (void)doRequestWithParams:(NSDictionary*)params{
    [self generateRequestWithUrl:self.requestUrl withParameters:params];
    
//    [_request startAsynchronous];
//    CIWDINFO(@"request %@ is created, URL is: %@", [self class], [_request url]);
}

- (void)dealloc {	
    _requestOperation = nil;
    _requestSerializer = nil;
}

/**缓存至本地硬盘*/
- (BOOL)onReceivedCacheData:(NSObject*)cacheData{
    // return yes to finish this request, return no to continue request from server
//    CIWDINFO(@"using cache data for request:%@", [self class]);
    if (!cacheData) {
        return NO;
    }
    if ([cacheData isKindOfClass:[NSDictionary class]]) {
        self.resultDic = (NSMutableDictionary *)cacheData;
        self.result = [[CIWRequestResult alloc] initWithCode:(self.resultDic)[@"result"]
                                             withMessage:@""];
        
        if (self.delegate) {
            if([self.delegate respondsToSelector:@selector(requestDidFinishLoad:)]){
                [self.delegate requestDidFinishLoad:self];
            }
        }else {
            if (_onRequestFinishBlock) {
                _onRequestFinishBlock(self);
            }
        }
        return YES;
    }else{
//        CIWDINFO(@"request:[%@],cache data should be handled by subclass", [self class]);
        return NO;
    }
}
#pragma mark - request delegate method
/**
  * 设置请求头
 */
- (void)requestDidReceiveReponseHeaders:(AFHTTPRequestOperationManager*)request{
    //do something
//    if ([request responseHeaders][@"Content-Length"]) {
//        _totalData = [(NSString*)[request responseHeaders][@"Content-Length"] longLongValue];
//        CIWDINFO(@"total size of zip file:%lld", _totalData);
//    }
    
}


/**
 *  检测下载进度
 */
- (void)request:(AFHTTPRequestOperationManager *)request didReceiveBytes:(long long)newLength{
    
}

- (void)requestStarted:(AFHTTPRequestOperationManager*)request {
	[self showIndicator:YES];
    if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(requestDidStartLoad:)]){
            [self.delegate requestDidStartLoad:self];
        }
    }else{
        if (_onRequestStartBlock) {
            _onRequestStartBlock(self);
        }
    }
}
/**
 *  网络请求成功
 */
- (void)requestFinished:(AFHTTPRequestOperation*)operation withResponseObject:(id)responseObject {
    
    [self showIndicator:NO];
    self.isCachedData = NO;
    self.isEtagCacheData = NO;
    
    //如果返回状态为缓存状态，直接还是返回缓存数据
    if([responseObject isKindOfClass:[NSDictionary class]]){
        NSString *errCode = [responseObject objectForKey:@"err"];
        if(errCode && [errCode isKindOfClass:[NSString class]] && [errCode isEqualToString:REQUEST_DATA_NOT_CHNAGE]){
            self.isEtagCacheData = YES;
            /**获取本地缓存数据*/
            NSDictionary *cacheResult = [self getRequestLocalCacheWithUrl:_cacheUrl];
            [self handleResultObject:cacheResult];
            
        }else{
            
            if([self saveTheCacheWithResponseObject:responseObject]) NSLog(@"数据缓存(Success)!");
            [self handleResultObject:responseObject];
        }
    }
    [self doRelease];
}

/**
 *  缓存数据
 */
- (BOOL)saveTheCacheWithResponseObject:(id)responseObject
{
    NSDictionary *results = responseObject;
    if (self.isCache || self.isUsingEtag) {
        NSString *filePath = CIWPathForReqeustDateCacheResource(self.fileName);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            return [NSKeyedArchiver archiveRootObject:results toFile:filePath];
        }
    }
    return NO;
}

/**
 *  网络请求失败
 */
- (void)requestFailed:(AFHTTPRequestOperation*)request withError:(NSError *)error {
    
    NSLog(@"%@",request.error);
	[self showIndicator:NO];
    if(self.isAlertNetError){
        [MessageView displayMessage:@"请检查您的网络是否连接!"];
    }
	if(self.delegate && [self.delegate respondsToSelector:@selector(request:didFailLoadWithError:)]){
		[self.delegate request:self didFailLoadWithError:request.error];
	}
    if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(request:didFailLoadWithError:)]){
            [self.delegate request:self didFailLoadWithError:request.error];
        }
    }else{
        if (_onRequestFailedBlock) {
            _onRequestFailedBlock(self,request.error);
        }
    }
	
    [self doRelease];
}


//上传文件追加方法
+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
    constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))constructingBlock
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request, NSError *error))onFailedBlock {
    
    CIWBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                         withIndicatorView:indiView
                                                         withCancelSubject:cancelSubject
                                                           constructingBodyWithBlock:constructingBlock
                                                            onRequestStart:onStartBlock
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:onCanceledBlock
                                                           onRequestFailed:onFailedBlock];
    
    
    [[CIWDataRequestManager sharedManager] addRequest:request];
}

- (id)initWithParameters:(NSDictionary*)params
       withIndicatorView:(UIView*)indiView
       withCancelSubject:(NSString*)cancelSubject
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))constructingBlock
          onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
       onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
       onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
         onRequestFailed:(void(^)(CIWBaseDataRequest *request, NSError *error))onFailedBlock {
    
    self = [super init];
    if(self) {
        self.requestUrl = [self getRequestUrl];
        self.indicatorView = indiView;
        
        if (cancelSubject && cancelSubject.length > 0) {
            _cancelSubject = cancelSubject;
        }
        
        if (_cancelSubject && _cancelSubject.length > 0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequest) name:_cancelSubject object:nil];
        }
        
        if (constructingBlock) {
            _constructingBodyWithBlock = [constructingBlock copy];
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
        
        _requestStartTime = [NSDate date];
        
        [self uploadRequestWithParams:params];

    }
    return self;
}

- (void)uploadRequestWithParams:(NSDictionary*)params{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self requestStarted:manager];
    
    NSLog(@"\n--------------RequstUrl-----------(POST upload)\n  %@\n   参数:\n%@\n\n",self.requestUrl, params);
    
    self.requestOperation = [manager POST:self.requestUrl parameters:params
                constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
                    if (_constructingBodyWithBlock) {
                        _constructingBodyWithBlock(formData);
                    }
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self requestFinished:operation withResponseObject:responseObject];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [self requestFailed:operation withError:error];
                }];
    
    self.requestSerializer = manager.requestSerializer;

    [self setNetWorkConfig];
}

@end
