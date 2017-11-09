//
//  storeBranch.m
//  jiabasha
//
//  Created by 金伟城 on 17/1/16.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "storeBranch.h"

@implementation storeBranch
- (NSDictionary *)attributeMapDictionary{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"store_id",                    @"storeId",
            @"branch_id",                   @"branchId",
            @"branch_name",                 @"branchName",
            @"address",                     @"address",
            @"rr_contact",                  @"rrContact",
            nil];
}

@end
