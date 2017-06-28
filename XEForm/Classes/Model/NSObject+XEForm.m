//
//  NSObject+XEForm.m
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import "NSObject+XEForm.h"

#import <objc/runtime.h>

#import "XEFormRowObject.h"
#import "XEFormConst.h"
#import "XEFormController.h"

static NSArray *_rows;
static XEFormController *_formController;

@implementation NSObject(XEForm)

- (NSArray *)objectsWithRows:(NSArray<XEFormRowObject *> *)rows formController:(XEFormController *)formController
{
    /** merge all row objects */
    NSMutableArray *allRows = [NSMutableArray array];
    // get objects(Predict type with class)
    NSArray *properties = [(NSObject *)self getRowObjectsFromClass];
    // exclude property
    NSSet<NSString *> *excludeProperties =  [self respondsToSelector:@selector(excludeProperties)] ? [self excludeProperties] : [NSSet set];
    NSArray *filterArray = [properties filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        XEFormRowObject *rowObject = (XEFormRowObject *)evaluatedObject;
        return ![excludeProperties containsObject:rowObject.key];
    }]];
    NSMutableDictionary *propertiesDic = [NSMutableDictionary dictionary];
    for (XEFormRowObject *rowObject in filterArray)
    {
        [rowObject configWithForm:self formController:formController];
        [propertiesDic setObject:rowObject forKey:rowObject.key];
    }
    // combine property and @selector(rows)
    if(rows.count > 0)
    {
        for (id row in rows)
        {
            if ([row isKindOfClass:[NSString class]])
            {
                XEFormRowObject *propertyObject = [propertiesDic objectForKey:row];
                propertyObject ? [allRows addObject:propertyObject] : nil;
            }
            else if([row isKindOfClass:[XEFormRowObject class]])
            {
                XEFormRowObject *rowObject = (XEFormRowObject *)row;
                if(rowObject.key.length > 0 && rowObject.valueClass && rowObject.type.length > 0)
                {
                    [rowObject configWithForm:self formController:formController];
                    [allRows addObject:rowObject];
                }
                else
                {
                    [NSException raise:XEFormsException format:@"Information of row at %lu  not enough!", (unsigned long)[rows indexOfObject:row]];
                }
            }
            else
            {
                [NSException raise:XEFormsException format:@"Unsupported row type: %@", [row class]];
            }
        }
    }
    else
    {
        [allRows addObjectsFromArray:filterArray];
    }
    return allRows;
}

- (NSArray<XEFormRowObject *> *)getRowObjectsFromClass
{
    static void *XEFormPropertiesKey = &XEFormPropertiesKey;
    
    NSMutableArray *objects = objc_getAssociatedObject(self, XEFormPropertiesKey);
    if (nil == objects)
    {
        // Get all form properties(except NSObject properties)
        objects = [NSMutableArray array];
        Class subclass = [self class];
        while (subclass != [NSObject class]) {
            unsigned int propertyCount;
            objc_property_t *propertyList = class_copyPropertyList(subclass, &propertyCount);
            for(unsigned int i = 0; i < propertyCount; i++)
            {
                // Get property name
                objc_property_t property = propertyList[i];
                XEFormRowObject *rowObject = [XEFormRowObject objectWithProperty:property];
                if(nil != rowObject)
                {
                    [objects addObject:rowObject];
                }
                
            }
            free(propertyList);
            subclass = [subclass superclass];
        }
        objc_setAssociatedObject(self, XEFormPropertiesKey, objects, OBJC_ASSOCIATION_RETAIN);
    }
    return [objects copy];
}

- (BOOL)canGetValueForKey:(NSString *)key
{
    //has key?
    if (![key length])
    {
        return NO;
    }
    
    //does a property exist for it?
    if ([[[self getRowObjectsFromClass] valueForKey:XEFormRowKey] containsObject:key])
    {
        return YES;
    }
    
    //is there a getter method for this key?
    if ([self respondsToSelector:NSSelectorFromString(key)])
    {
        return YES;
    }
    
    //does it override valueForKey?
    if ([self isOverrideSelector:@selector(valueForKey:)])
    {
        return YES;
    }
    
    //does it override valueForUndefinedKey?
    if ([self isOverrideSelector:@selector(valueForUndefinedKey:)])
    {
        return YES;
    }
    
    //it will probably crash
    return NO;
}

-(BOOL)canSetValueForKey:(NSString *)key
{
    //has key?
    if (![key length])
    {
        return NO;
    }
    
    //does a property exist for it?
    if ([[[self getRowObjectsFromClass] valueForKey:XEFormRowKey] containsObject:key])
    {
        return YES;
    }
    
    //is there a setter method for this key?
    if ([self respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [[key substringToIndex:1] uppercaseString], [key substringFromIndex:1]])])
    {
        return YES;
    }
    
    //does it override setValueForKey?
    if ([self isOverrideSelector:@selector(setValue:forKey:)])
    {
        return YES;
    }
    
    //does it override setValue:forUndefinedKey?
    if ([self isOverrideSelector:@selector(setValue:forUndefinedKey:)])
    {
        return YES;
    }
    
    //it will probably crash
    return NO;
}

- (BOOL)isOverrideSelector:(SEL)selector
{
    Class formClass = [self class];
    while (formClass && formClass != [NSObject class])
    {
        unsigned int numberOfMethods;
        Method *methods = class_copyMethodList(formClass, &numberOfMethods);
        for (unsigned int i = 0; i < numberOfMethods; i++)
        {
            if (method_getName(methods[i]) == selector)
            {
                free(methods);
                return YES;
            }
        }
        if (methods) free(methods);
        formClass = [formClass superclass];
    }
    return NO;
}

#pragma mark - Getter & setter(Runtime)

-(NSArray<XEFormRowObject *> *)rows
{
    NSArray<XEFormRowObject *> *preRows = objc_getAssociatedObject(self, &_rows);
    if (nil == preRows)
    {
        preRows = [self objectsWithRows:nil formController:self.formController];
    }
    return preRows;
}

-(void)setRows:(NSArray<XEFormRowObject *> *)rows
{
    NSArray<XEFormRowObject *> *preRows = self.rows;
    if(preRows == nil)
    {
        
    }
    /** merge all attributes
     @selector(excludeProperties) > @selector(rows) > property forecast
     */
    NSArray *allRows = [self objectsWithRows:rows formController:self.formController];
    objc_setAssociatedObject(self, &_rows, allRows, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(XEFormController *)formController
{
    return objc_getAssociatedObject(self, &_formController);
}

-(void)setFormController:(XEFormController *)formController
{
    objc_setAssociatedObject(self, &_formController, formController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Config formController to every rowObject in rows
    for (XEFormRowObject *row in self.rows)
    {
        row.formController = formController;
    }
}

@end
