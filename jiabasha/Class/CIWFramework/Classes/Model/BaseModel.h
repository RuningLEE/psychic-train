//
//  BaseModel.h
//  weddingBusiness
//
//  Created by GarrettGao on 15/1/7.
//  Copyright (c) 2015年 HunBoHui. All rights reserved.
//

#import "CIWBaseModelObject.h"

@interface BaseModel : CIWBaseModelObject

/**将数组类型对象数据转成数据模型model中*/
+ (NSArray *)createModelsArrayByResults:(NSArray *)results;


/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
- (NSDictionary *)objectClassInArray;
@end

