//
//  GetRenovationHomeRequest.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/18.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "Banner.h"
#import "Category.h"
#import "VipPrice.h"
#import "Activity.h"
#import "RenovationBrand.h"
#import "GetRenovationHomeRequest.h"

@implementation GetRenovationHomeRequest


-(CIWRequestMethod)getRequestMethod
{
    return CIWRequestMethodPost;
}

-(NSString*)getURI
{
    return @"/common/home/mall";
}
- (void)processResult
{
    if([RESPONSE_OK isEqualToString:self.errCode] || [@"OK" isEqualToString:self.errCode]){
        
        NSDictionary *data = [self.resultDic objectForKey:@"data"];
        
        if ([data isEqual:[NSNull null]]) {
            return;
        }
        
        //banner
        NSArray *bannerList = [data objectForKey:@"banner"];
        if(bannerList && bannerList.count){
            [self.resultDic setObject:[Banner createModelsArrayByResults:bannerList] forKey:@"banner"];
        }
        
        // vipprice  会员专场
        NSArray *vippriceList = [data objectForKey:@"vipprice"];
        if(vippriceList && vippriceList.count){
            [self.resultDic setObject:[VipPrice createModelsArrayByResults:vippriceList] forKey:@"vipprice"];
        }
        
        // brand  品牌专场
        NSArray *brandList = [data objectForKey:@"brand"];
        if(brandList && brandList.count){
            [self.resultDic setObject:[RenovationBrand createModelsArrayByResults:brandList] forKey:@"brand"];
        }
        
        // category 分类
        NSArray *categoryList = [data objectForKey:@"category"];
        if(categoryList && categoryList.count){
            [self.resultDic setObject:[CategorySelected createModelsArrayByResults:categoryList] forKey:@"category"];
        }
        
        // Activity 活动专场
        NSArray *ActivityList = [data objectForKey:@"activity"];
        if(ActivityList && ActivityList.count){
            [self.resultDic setObject:[Activity createModelsArrayByResults:ActivityList] forKey:@"activity"];
        }
      
    }
}

@end
