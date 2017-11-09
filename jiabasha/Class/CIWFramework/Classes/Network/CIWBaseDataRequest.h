//
//  CIWBaseDataRequest.h
//
#import "CIWRequestResult.h"
#import "DataCacheManager.h"
#import "CIWMaskActivityView.h"


/**请求内容没有发生改变 状态码*/
#define REQUEST_DATA_NOT_CHNAGE @"hapn.u_data_not_changed"


typedef enum{
    CIWRequestMethodGet = 0,
    CIWRequestMethodPost = 1,           // content type = @"application/x-www-form-urlencoded"
    CIWRequestMethodMultipartPost = 2   // content type = @"multipart/form-data"
} CIWRequestMethod;

@class CIWBaseDataRequest;

@protocol DataRequestDelegate <NSObject>
@optional
- (void)requestDidStartLoad:(CIWBaseDataRequest*)request;
- (void)requestDidFinishLoad:(CIWBaseDataRequest*)request;
- (void)requestDidCancelLoad:(CIWBaseDataRequest*)request;
- (void)request:(CIWBaseDataRequest*)request progressChanged:(float)progress;
- (void)request:(CIWBaseDataRequest*)request didFailLoadWithError:(NSError*)error;
@end

@interface CIWBaseDataRequest : NSObject {      
    NSString *_cancelSubject;           
    BOOL _useSilentAlert;       
    
    NSDate *_requestStartTime;
    BOOL _usingCacheData;
    NSString *_cacheKey;
    DataCacheManagerCacheType _cacheType;
    CIWMaskActivityView *_maskActivityView;
    NSString *_filePath;
    
    void (^_onRequestStartBlock)(CIWBaseDataRequest *);
    void (^_onRequestFinishBlock)(CIWBaseDataRequest *);
    void (^_onRequestCanceled)(CIWBaseDataRequest *);
    void (^_onRequestFailedBlock)(CIWBaseDataRequest *,NSError *);
    void (^_onRequestProgressChangedBlock)(CIWBaseDataRequest *,float);
    
    //progress related
    
    long long _totalData;
    long long _downloadedData;
    float _currentProgress;
}

@property (nonatomic, assign) BOOL isCachedData;    //是否是缓存数据
@property (nonatomic, assign) BOOL isEtagCacheData; //是否是etag缓存数据
@property (nonatomic, assign) BOOL isCache;         //是否要缓存数据
@property (nonatomic, assign) BOOL isAlertNetError; //是否提示网络连接失败（默认yes）
@property (nonatomic, assign) BOOL isUsingEtag;      //是否使用etag缓存策略
@property (nonatomic, strong) NSString *errCode;    //返回状态码
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) id<DataRequestDelegate> delegate;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) NSMutableDictionary *resultDic;
@property (nonatomic, strong) NSString *resultString;
@property (nonatomic, strong) CIWRequestResult *result;
@property (nonatomic, strong,readonly) NSDictionary *parameters;

#pragma mark - init methods using delegate
+ (void)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withCancelSubject:(NSString*)cancelSubject;

+ (void)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate 
                   withParameters:(NSDictionary*)params;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
               withCacheKey:(NSString*)cache
              withCacheType:(DataCacheManagerCacheType)cacheType;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withCancelSubject:(NSString*)cancelSubject;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withIndicatorView:(UIView*)indiView;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
               withCacheKey:(NSString*)cache
              withCacheType:(DataCacheManagerCacheType)cacheType;

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject;

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath;

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withRequestUrl:(NSString*)url
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath;

#pragma mark - init methods using blocks

+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock;

+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock;

+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock;




#pragma mark - file download related init methods 

+ (void)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath;

//添加唯一标识   区分请求
+ (void)requestWithParameters:(NSDictionary*)params
               withRequestTag:(NSInteger)tag
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock;


//只缓存，不返回缓存数据
+ (void)requestWithParameters:(NSDictionary*)params
                withCacheType:(DataCacheManagerCacheType)cacheType
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock;

//缓存数据是否
+ (void)requestWithParameters:(NSDictionary*)params
              withIsCacheData:(BOOL)isCache
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock;

//是否使用etag缓存策略
+ (void)requestWithParameters:(NSDictionary*)params
              withIsUsingEtag:(BOOL)isUsingEtag
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock;

/**是否使用etag 和 缓存*/
+ (void)requestWithParameters:(NSDictionary*)params
              withIsCacheData:(BOOL)isCache
              withIsUsingEtag:(BOOL)isUsingEtag
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock;

+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
                 withFilePath:(NSString*)localFilePath
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onProgressChanged:(void(^)(CIWBaseDataRequest *request,float progress))onProgressChangedBlock;

- (id)initWithParameters:(NSDictionary*)params
          withRequestUrl:(NSString*)url
       withIndicatorView:(UIView*)indiView
       withCancelSubject:(NSString*)cancelSubject
         withSilentAlert:(BOOL)silent
            withCacheKey:(NSString*)cache
         withIsCacheData:(BOOL)isCache
           withCacheType:(DataCacheManagerCacheType)cacheType
         withIsUsingEtag:(BOOL)isUsingEtag
            withFilePath:(NSString*)localFilePath
          onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
       onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
       onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
         onRequestFailed:(void(^)(CIWBaseDataRequest *request))onFailedBlock
       onProgressChanged:(void(^)(CIWBaseDataRequest *request,float))onProgressChangedBlock;

#pragma mark - public methods
//+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse;
- (void)uploadRequestWithParams:(NSDictionary*)params;
- (void)doRequestWithParams:(NSDictionary*)params;
- (NSStringEncoding)getResponseEncoding;
- (NSDictionary*)getStaticParams;
- (CIWRequestMethod)getRequestMethod;
- (NSString*)getRequestUrl;
- (NSString*)getRequestHost;
- (void)processResult;
- (BOOL)isSuccess;
- (NSString*)encodeURL:(NSString *)string;
- (void)showIndicator:(BOOL)bshow;
- (BOOL)handleResultObject:(id)responseObject;
- (BOOL)onReceivedCacheData:(NSObject*)cacheData;
- (void)doRelease;
@end
