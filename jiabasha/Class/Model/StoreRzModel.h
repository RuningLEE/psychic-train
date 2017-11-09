//
//  StoreRzModel.h
//  jiabasha
//
//  Created by 金伟城 on 17/2/17.
//  Copyright © 2017年 hunbohui. All rights reserved.
//

#import "BaseModel.h"

@interface StoreRzModel : BaseModel
@property (strong ,nonatomic) NSArray *honor;
@property (strong ,nonatomic) NSDictionary *attrs;
@property (strong ,nonatomic) NSArray *picUrls;
@property (strong ,nonatomic) NSString *describe;
@end
