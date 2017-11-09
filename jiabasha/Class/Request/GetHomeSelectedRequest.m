//
//  GetHomeSelectedRequest.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/4.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetHomeSelectedRequest.h"
#import "Banner.h"
#import "Category.h"
#import "Activity.h"
#import "Example.h"

@implementation GetHomeSelectedRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/home/selected";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode]){
        
        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        
        if ([data isEqual:[NSNull null]] || data.count == 0) {
            return;
        }
        
        //banner
        NSArray *bannerList = [data objectForKey:@"banner"];
        if(bannerList && bannerList.count){
            [self.resultDic setObject:[Banner createModelsArrayByResults:bannerList] forKey:@"banner"];
        }
        
        //category
        NSArray *categoryList = [data objectForKey:@"category"];
        if(categoryList && categoryList.count){
            [self.resultDic setObject:[CategorySelected createModelsArrayByResults:categoryList] forKey:@"category"];
        }
        
        //activity
        NSArray *activityList = [data objectForKey:@"activity"];
        if(activityList && activityList.count){
            [self.resultDic setObject:[Activity createModelsArrayByResults:activityList] forKey:@"activity"];
        }
        
        //example
        NSArray *exampleList = [data objectForKey:@"example"];
        if(exampleList && exampleList.count){
            [self.resultDic setObject:[Example createModelsArrayByResults:exampleList] forKey:@"example"];
        }
    }
}

@end
