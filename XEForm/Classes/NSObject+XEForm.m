//
//  NSObject+XEForm.m
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import "NSObject+XEForm.h"

#import <objc/runtime.h>

#import "XEFormObject.h"

static NSArray *_rows;

@implementation NSObject(XEForm)

- (NSString *)formDescription
{
    for (Class fieldClass in @[[NSString class], [NSNumber class], [NSDate class]])
    {
        if ([self isKindOfClass:fieldClass])
        {
            return [self description];
        }
    }
    for (Class fieldClass in @[[NSDictionary class], [NSArray class], [NSSet class], [NSOrderedSet class]])
    {
        if ([self isKindOfClass:fieldClass])
        {
            id collection = self;
            if (fieldClass == [NSDictionary class])
            {
                collection = [collection allValues];
            }
            NSMutableArray *array = [NSMutableArray array];
            for (id object in collection)
            {
                NSString *description = [object formDescription];
                if ([description length]) [array addObject:description];
            }
            return [array componentsJoinedByString:@", "];
        }
    }
    if ([self isKindOfClass:[NSDate class]])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
        return [formatter stringFromDate:(NSDate *)self];
    }
    return @"CAN'T RECOGNISE";
}

- (NSArray<XEFormObject *> *)getFormObjects
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
                XEFormObject *formObject = [XEFormObject objectWithProperty:property];
                if(nil != formObject)
                {
                    [objects addObject:formObject];
                }
                
            }
            free(propertyList);
            subclass = [subclass superclass];
        }
        objc_setAssociatedObject(self, XEFormPropertiesKey, objects, OBJC_ASSOCIATION_RETAIN);
    }
    return [objects copy];
}

#pragma mark - Getter & setter(Runtime)

-(NSArray *)rows
{
    return objc_getAssociatedObject(self, &_rows);
}

-(void)setRows:(NSArray *)rows
{
    objc_setAssociatedObject(self, &_rows, rows, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
