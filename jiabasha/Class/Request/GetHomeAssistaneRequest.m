//
//  GetHomeAssistaneRequest.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/13.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetHomeAssistaneRequest.h"
#import "Decorate.h"

@implementation GetHomeAssistaneRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/home/assistant";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        
        if ([data isEqual:[NSNull null]] || data.count == 0) {
            return;
        }
        
        //zxread
        NSArray *bannerList = [data objectForKey:@"zxread"];
        if(bannerList && bannerList.count){
            [self.resultDic setObject:[Decorate createModelsArrayByResults:bannerList] forKey:KEY_ZXREAD];
        }
        
        //zxing
        NSArray *categoryList = [data objectForKey:@"zxing"];
        if(categoryList && categoryList.count){
            [self.resultDic setObject:[Decorate createModelsArrayByResults:categoryList] forKey:KEY_ZXIND];
        }
    }
}

@end
