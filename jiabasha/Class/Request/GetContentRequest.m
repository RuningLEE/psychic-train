//
//  GetContentRequest.m
//  jiabasha
//
//  Created by guok on 17/1/16.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetContentRequest.h"
#import "AdContent.h"

@implementation GetContentRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/ad/get";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        NSArray *arrayList = [self.resultDic objectForKey:@"data"];
        if(arrayList && arrayList.count){
            [self.resultDic setObject:[AdContent createModelsArrayByResults:arrayList] forKey:KEY_ADCONTENT];
        }
    }
}

@end
