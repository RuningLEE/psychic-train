//
//  GetExampleChildRequest.m
//  jiabasha
//
//  Created by 金伟城 on 17/2/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "ExampleChild.h"
#import "GetExampleChildRequest.h"

@implementation GetExampleChildRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/mall/example/child";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode] || [@"OK" isEqualToString:self.errCode]){
        
        NSDictionary *dataDic = [self.resultDic objectForKey:@"data"];
        
        if (dataDic == nil) {
            return;
        }
        NSArray *arrayList = [NSArray arrayWithObject:dataDic];
        if(arrayList && arrayList.count){
            [self.resultDic setObject:[ExampleChild createModelsArrayByResults:arrayList] forKey:@"exampleChild"];
        }
        
        
    }
}


@end
