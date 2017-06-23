//
//  XEFormObject.m
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import "XEFormObject.h"

#import "XEFormUtils.h"
#import "XEFormController.h"
#import "NSObject+XEForm.h"

@interface XEFormObject ()

@property (nonatomic, copy, readwrite) NSString *key;
@property (nonatomic, strong, readwrite) id value;
@property (nonatomic, strong, readwrite) NSArray *options;
@property (nonatomic, strong, readwrite) id placeholder;
@property (nonatomic, copy, readwrite) NSString *type;

@end

@implementation XEFormObject

-(instancetype)init
{
    
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+(NSArray *)objectsWithForm:(id)form controller:(XEFormController *)formController
{
    /** merge all attributes
        @selector(excludedRows) > @selector(XXXrow) > @selector(rows) > property forecast
     */
    NSMutableArray *rows;
    // get objects(Predict type with class)
    NSArray *properties = [form getFormObjects];
//    NSMutableDictionary *propertiesDic = [NSMutableDictionary dictionary];
//    for (NSDictionary *propertyDict in properties)
//    {
//        [propertyDict objectForKey:XEFormRowKey] ? [propertiesDic setObject:propertyDict forKey:[propertyDict objectForKey:XEFormRowKey]] : nil;
//    }
//    // attributs seeting in @selector(rows) and @selector(extraRows)
//    NSMutableArray *rowsDicArray = [form respondsToSelector:@selector(rows)] ? [[form rows] mutableCopy] : nil;
//    NSArray *excludeRows = [form respondsToSelector:@selector(excludeRows)] ? [form excludeRows] : nil;
//    // combine properties and @selector(rows)
    

    
    return properties;
}

+(instancetype)objectWithProperty:(objc_property_t)property
{
    NSString *key, *type;
    Class class;
    if(XEFormObjectValueWithProperty(property, &key, class, &type))
    {
        XEFormObject *formObject = [[XEFormObject alloc] initWithKey:key Class:class type:type];
        return formObject;
    }
    else
    {
        return nil;
    }
}

- (instancetype)initWithKey:(NSString *)key Class:(Class)class type:(NSString *)type
{
    if (self = [super init])
    {
        self.key = key;
        self.valueClass = class;
        self.type = type;
    }
    return self;
}

-(instancetype)initWithForm:(id)form controller:(XEFormController *)formController attributes:(NSDictionary *)attributes
{
    if (self = [super init])
    {
        NSArray *properties = [form getFormObjects];
        
        
        
    }
    return self;
}

@end
