//
//  CheckFindPwdCodeRequest.m
//  
//
//  Created by Jianyong Duan on 2017/1/13.
//
//

#import "CheckFindPwdCodeRequest.h"

@implementation CheckFindPwdCodeRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/user/account/check_find_pwd_code";
}

- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        
    }
}

@end
