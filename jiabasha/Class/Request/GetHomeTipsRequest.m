//
//  GetHomeTipsRequest.m
//  jiabasha
//
//  Created by Jianyong Duan on 2017/1/4.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "GetHomeTipsRequest.h"
#import "Banner.h"
#import "Knowledge.h"
#import "Classroom.h"
#import "Strategy.h"

@implementation GetHomeTipsRequest

-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/home/tips";
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
        
        //knowledge
        NSArray *knowledgeList = [data objectForKey:@"knowledge"];
        if(knowledgeList && knowledgeList.count){
            [self.resultDic setObject:[Knowledge createModelsArrayByResults:knowledgeList] forKey:@"knowledge"];
        }
        
        //classroom
        NSArray *classroomList = [data objectForKey:@"classroom"];
        if(classroomList && classroomList.count){
            [self.resultDic setObject:[Classroom createModelsArrayByResults:classroomList] forKey:@"classroom"];
        }
        
        //strategy
        NSArray *strategyList = [data objectForKey:@"strategy"];
        if(strategyList && strategyList.count){
            [self.resultDic setObject:[Strategy createModelsArrayByResults:strategyList] forKey:@"strategy"];
        }
    }
}

@end
