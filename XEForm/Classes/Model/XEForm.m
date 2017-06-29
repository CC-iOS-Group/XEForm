//
//  XEForm.m
//  Pods
//
//  Created by 丁明 on 2017/6/29.
//
//

#import "XEForm.h"

#import "XEFormConst.h"
#import "XEFormRowObject.h"
#import "XEFormSectionObject.h"

@interface XEForm ()
{
    BOOL _hasSetRows;
}

@property (nonatomic, strong, readwrite) NSArray<XEFormRowObject *> *propertyRows;

@property (nonatomic, strong, readwrite) NSArray<XEFormSectionObject *> *sections;

@end

@implementation XEForm

@synthesize rows = _rows;

#pragma mark - Public method


- (BOOL)canGetValueForKey:(NSString *)key
{
    //has key?
    if (![key length])
    {
        return NO;
    }
    
    //does a property exist for it?
    if ([[self.propertyRows valueForKey:XEFormRowKey] containsObject:key])
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
    if ([[self.propertyRows valueForKey:XEFormRowKey] containsObject:key])
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

#pragma mark - Customizing

-(NSSet<NSString *> *)excludeProperties
{
    return [NSSet set];
}
#pragma mark - Private method

- (NSArray<XEFormRowObject *> *)getRowsFromProperties
{
    NSMutableArray *objects = [NSMutableArray array];
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
    return objects;
}

- (NSArray *)mergeObjectsWithRows:(NSArray<XEFormRowObject *> *)rows
{
    /** merge all row objects */
    NSMutableArray *allRows = [NSMutableArray array];
    // get objects(Predict type with class)
    NSArray *properties = self.propertyRows;
    // exclude property
    NSSet<NSString *> *excludeProperties =  [self respondsToSelector:@selector(excludeProperties)] ? [self excludeProperties] : [NSSet set];
    NSArray *filterArray = [properties filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        XEFormRowObject *rowObject = (XEFormRowObject *)evaluatedObject;
        return ![excludeProperties containsObject:rowObject.key];
    }]];
    NSMutableDictionary *propertiesDic = [NSMutableDictionary dictionary];
    for (XEFormRowObject *rowObject in filterArray)
    {
        [rowObject configWithForm:self];
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
                if(propertyObject &&
                   ![[allRows valueForKey:XEFormRowKey] containsObject:propertyObject.key])
                {
                    [allRows addObject:propertyObject];
                }
            }
            else if([row isKindOfClass:[XEFormRowObject class]])
            {
                XEFormRowObject *rowObject = (XEFormRowObject *)row;
                if(rowObject.key.length > 0 && rowObject.valueClass && rowObject.type.length > 0)
                {
                    [rowObject configWithForm:self];
                    if([[allRows valueForKey:XEFormRowKey] containsObject:rowObject.key])
                    {
                        [allRows addObject:rowObject];
                    }
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

#pragma mark - Getter & setter

-(NSArray<XEFormRowObject *> *)propertyRows
{
    if(nil == _propertyRows)
    {
        _propertyRows = [self getRowsFromProperties];
    }
    return _propertyRows;
}


-(NSArray<XEFormRowObject *> *)rows
{
    if(nil == _rows)
    {
        if(!_hasSetRows)
        {
            _rows = [self mergeObjectsWithRows:nil];
        }
        else
        {
            _rows = [NSArray array];
        }
    }
    return _rows;
}

-(void)setRows:(NSArray<XEFormRowObject *> *)rows
{
    _rows = [self mergeObjectsWithRows:rows];
    _sections = [XEFormSectionObject sectionsWithForm:self];
    _hasSetRows = YES;
}


-(NSArray<XEFormSectionObject *> *)sections
{
    if (nil == _sections)
    {
        _sections = [XEFormSectionObject sectionsWithForm:self];
    }
    return _sections;
}


@end
