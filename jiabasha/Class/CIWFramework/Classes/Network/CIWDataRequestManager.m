//
//  CIWDataRequestManager.m
//

#import "CIWDataRequestManager.h"
#import "CIWObjectSingleton.h"
#import "CIWBaseDataRequest.h"

@interface CIWDataRequestManager()
- (void)restore;
@end

@implementation CIWDataRequestManager
CIWOBJECT_SINGLETON_BOILERPLATE(CIWDataRequestManager, sharedManager)
- (id)init{
    self = [super init];
    if(self){
        [self restore];
    }
    return self;
}

- (void)dealloc{
}

#pragma mark - private methods
- (void)restore{
    _requests = [[NSMutableArray alloc] init];
}
#pragma mark - public methods

- (void)addRequest:(CIWBaseDataRequest*)request{
    [_requests addObject:request];
}
- (void)removeRequest:(CIWBaseDataRequest*)request{
    [_requests removeObject:request];
}

@end
