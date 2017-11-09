//
//  BaseModel.m
//  weddingBusiness
//
//  Created by GarrettGao on 15/1/7.
//  Copyright (c) 2015年 HunBoHui. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel
+ (NSArray *)createModelsArrayByResults:(NSArray *)results{
    if (![results isKindOfClass:[NSArray class]]) {
        return [NSArray array];
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in results) {
        BaseModel *model = [[self alloc] initWithDataDic:dic];
        [array addObject:model];
        model = nil;
    }
    return array;
}


- (void)encodeWithCoder:(NSCoder *)encoder{
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    if (attrMapDic == nil) {
        return;
    }
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL getSel = NSSelectorFromString(attributeName);
        if ([self respondsToSelector:getSel]) {
            id valueObj = [self valueForKey:attributeName];
            if (valueObj) {
                [encoder encodeObject:valueObj forKey:attributeName];
            }
        }
    }
}


/**重写父类的方法，增强解析功能，支持多层解析和类型识别
 * 注：为了保证源代码的原始性，在子类中重写了该方法，未修改原框架代码
 */
-(void)setAttributes:(NSDictionary*)dataDic{
    if (![dataDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    if (attrMapDic == nil) {
        return;
    }
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL sel = [self getSetterSelWithAttibuteName:attributeName];
        
        if ([self respondsToSelector:sel]) {
            
            Class cla = [self getPropertyClassType:attributeName];
            NSString *dataDicKey = [attrMapDic objectForKey:attributeName];
                        
            id data = [self getDataWithDataKey:dataDicKey withResultData:dataDic];
            
            if(cla && data){
                
                if ([data isKindOfClass:[NSNumber class]]) {
                    
                    data = [NSString stringWithFormat:@"%@",data];
                    
                }else if ([data isKindOfClass:[NSNull class]]) {
                    
                    data = nil;
                    
                }else if ([data isKindOfClass:[NSArray class]]){
                    
                    if(cla != [NSArray class]){
                        data = nil;
                        
                    }else{
                        
                        NSDictionary *arrayKeyValueDic = [self objectClassInArray];
                        if(arrayKeyValueDic){
                            id classObject = [arrayKeyValueDic objectForKey:attributeName];
                            if(classObject && [classObject isKindOfClass:[NSString class]]){
                                Class mod = NSClassFromString(classObject);
                                if(mod){
                                    data = [mod createModelsArrayByResults:data];
                                }
                            }else if (classObject && [classObject isSubclassOfClass:[BaseModel class]]){
                                data = [classObject createModelsArrayByResults:data];
                            }
                        }
                    }
                    
                }else if ( [data isKindOfClass:[NSDictionary class]]){
                    
                    if([cla isSubclassOfClass:[BaseModel class]]){
                        data = [[cla alloc] initWithDataDic:data];
                    }else if(cla != [NSDictionary class]){
                        data = nil;
                    }
                }
            }
            [self performSelectorOnMainThread:sel
                                   withObject:data
                                waitUntilDone:[NSThread isMainThread]];
        }
    }
}

/**通过属性名获取属性的类型
 *  注：目前只能识别对象的类型，基本类型没有做处理
 */
- (Class)getPropertyClassType:(NSString *)propertyString{
    
    Class cls = [self class];
    const char *propertyName = [propertyString cStringUsingEncoding:NSASCIIStringEncoding];
    objc_property_t property = class_getProperty(cls, propertyName);
    if(property){
        NSString *attrs = @(property_getAttributes(property));
        if([self originString:attrs isIncludeTheString:@"@\""]){
            NSArray *ar = [attrs componentsSeparatedByString:@"\""];
            if(ar.count>1){
                NSString *typeName = [ar objectAtIndex:1];
                if(typeName && typeName.length){
                    return NSClassFromString(typeName);
                }
            }
        }
    }
    return nil;
}


/**获取某个key的接口数据
 @ key：接口字段，如果包含 . 或 [] ,则支持多层取值;
        .  代表 SEL:objectForKey:
        [] 代表 SEL:objectIndex:
 */
- (id)getDataWithDataKey:(NSString *)key withResultData:(NSDictionary *)dataDic{
    
    
    id data = nil;
    
    //是否存在多成数据取值
    if([self originString:key isIncludeTheString:@"."] ||
       [self originString:key isIncludeTheString:@"["]){
        data = dataDic;
        
        NSArray *keyArray = [key componentsSeparatedByString:@"."];
        
        for(NSString *k in keyArray){
            
            if([self originString:k isIncludeTheString:@"["] &&
               [self originString:k isIncludeTheString:@"]"]){
                
                //解析 "info[1][2]" 这种字段
                NSArray *indexArray = [k componentsSeparatedByString:@"["];
                int i = 0;
                for(NSString *key in indexArray){
                    if(i == 0 && data && [data isKindOfClass:[NSDictionary class]]){
                        data = [data objectForKey:key];
                        continue;
                    }else if(data && [data isKindOfClass:[NSArray class]]){
                        NSString *originKey = [key stringByReplacingOccurrencesOfString:@"]" withString:@""];
                        int index = [originKey intValue];
                        NSArray *ar = data;
                        if(ar.count>index){
                            data = [ar objectAtIndex:index];
                        }else{
                            data = nil;
                            break;
                        }
                    }else{
                        data = nil;
                        break;
                    }
                    i ++;
                }
            }else{
                //解析 . 字段
                if(data && [data isKindOfClass:[NSDictionary class]]){
                    data = [data objectForKey:k];
                }else{
                    data = nil;
                    break;
                }
            }
        }
    }else{
        data = [dataDic objectForKey:key];
    }
    return data;
}

- (NSDictionary *)objectClassInArray{
    return nil;
}


/**  判断某个字符串是否包含某个字符串*/
- (BOOL)originString:(NSString *)originString isIncludeTheString:(NSString *)string
{
    if(originString && string){
        NSRange range = [originString rangeOfString:string];//判断字符串
        return (range.location !=NSNotFound);
    }
    return NO;
}


@end
