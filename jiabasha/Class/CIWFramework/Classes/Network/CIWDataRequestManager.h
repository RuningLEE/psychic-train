//
//  CIWDataRequestManager.h
//

#import <Foundation/Foundation.h>
@class CIWBaseDataRequest;

@interface CIWDataRequestManager : NSObject{
    NSMutableArray *_requests;
}
+ (CIWDataRequestManager *)sharedManager;

- (void)addRequest:(CIWBaseDataRequest*)request;
- (void)removeRequest:(CIWBaseDataRequest*)request;
@end
