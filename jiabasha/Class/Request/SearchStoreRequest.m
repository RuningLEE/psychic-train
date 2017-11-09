//
//  SearchStoreRequest.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/9.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "SearchStoreRequest.h"
#import "Store.h"

@implementation SearchStoreRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/search/store";
}

- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        
        if([data isKindOfClass:[NSDictionary class]]){
            
            if ([data objectForKey:@"total"]) {
                [self.resultDic setObject:[data objectForKey:@"total"] forKey:@"total"];
            }
            
            NSDictionary *dicTags = [NSDictionary dictionaryWithDictionary:[data objectForKey:@"tag_map"] ];
            if (dicTags != nil) {
                [self.resultDic setObject:dicTags forKey:@"tags"];
            }
            
            NSArray *arrayList = [data objectForKey:@"data"];
            if(arrayList && arrayList.count){
                [self.resultDic setObject:[Store createModelsArrayByResults:arrayList] forKey:@"store"];
            }
        }
    }
}


@end
