//
//  CIWBaseModelObject.h
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataCacheManager.h"
@interface CIWBaseModelObject :NSObject <NSCoding> {
    
}
-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;


/**获取属性的setter方法*/
-(SEL)getSetterSelWithAttibuteName:(NSString*)attributeName;

@end
