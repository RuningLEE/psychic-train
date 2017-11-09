//
//  CIWAFBaseDataRequest.h
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CIWRequestResult.h"
#import "CIWBaseDataRequest.h"
#import "AFURLRequestSerialization.h"

@class AFHTTPRequestOperationManager;
@class AFHTTPRequestSerializer;
@class AFHTTPRequestOperation;
/**
 * NOTE:BaseDataRequest will handle it`s own retain/release lifecycle management, no need to release it manually
 */
@interface CIWAFBaseDataRequest : CIWBaseDataRequest{
    
    AFHTTPRequestSerializer *_requestSerializer;
    AFHTTPRequestOperation *_requestOperation;
    
    
    void (^_constructingBodyWithBlock)(id <AFMultipartFormData> formData);
}

@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;
@property (nonatomic, strong) AFHTTPRequestOperation *requestOperation;

/**
 *  取消某个网络取消*/
+ (void)cancelRequestWithCancelSubject:(NSString *)cancelSubject;

- (void)requestDidReceiveReponseHeaders:(AFHTTPRequestOperationManager*)request;

- (void)setNetWorkConfig;

//上传文件追加方法
+ (void)requestWithParameters:(NSDictionary*)params
            withIndicatorView:(UIView*)indiView
            withCancelSubject:(NSString*)cancelSubject
    constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
               onRequestStart:(void(^)(CIWBaseDataRequest *request))onStartBlock
            onRequestFinished:(void(^)(CIWBaseDataRequest *request))onFinishedBlock
            onRequestCanceled:(void(^)(CIWBaseDataRequest *request))onCanceledBlock
              onRequestFailed:(void(^)(CIWBaseDataRequest *request, NSError *error))onFailedBlock;

@end
