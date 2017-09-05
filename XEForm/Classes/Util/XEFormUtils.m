//
//  XEFormUtils.m
//  Pods
//
//  Created by 丁明 on 2017/8/30.
//
//

#import "XEFormUtils.h"

static NSSet *nsObjectProperties;


#pragma mark - UI
CGFloat XEFormLabelMinFontSize(UILabel *label)
{
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
    
    if (![label respondsToSelector:@selector(setMinimumScaleFactor:)])
    {
        return label.minimumFontSize;
    }
    
#endif
    
    return label.font.pointSize * label.minimumScaleFactor;
}


void XEFormLabelSetMinFontSize(UILabel *label, CGFloat fontSize)
{
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
    
    if (![label respondsToSelector:@selector(setMinimumScaleFactor:)])
    {
        label.minimumFontSize = fontSize;
    }
    else
        
#endif
        
    {
        label.minimumScaleFactor = fontSize / label.font.pointSize;
    }
}

#pragma mark - Data

Class XEFormClassFromString(NSString *className)
{
    Class cls = NSClassFromString(className);
    if (className && !cls)
    {
        //might be a Swift class; time for some hackery!
        className = [@[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"],
                       className] componentsJoinedByString:@"."];
        //try again
        cls = NSClassFromString(className);
    }
    return cls;
}

NSSet* getNSObjectProperties()
{
    if(nsObjectProperties == nil)
    {
        NSMutableSet *tempNSObjectProperties = [NSMutableSet setWithArray:@[@"description", @"debugDescription", @"hash", @"superclass"]];
        unsigned int propertyCount;
        objc_property_t *propertyList = class_copyPropertyList([NSObject class], &propertyCount);
        for(unsigned int i = 0; i< propertyCount; i++)
        {
            objc_property_t property = propertyList[i];
            const char *propertyName = property_getName(property);
            [tempNSObjectProperties addObject:@(propertyName)];
        }
        free(propertyList);
        nsObjectProperties = [tempNSObjectProperties copy];
    }
    return nsObjectProperties;
}


BOOL XEFormRowObjectValueWithProperty(objc_property_t property, NSString **key, Class *rowValueClass, NSString **type)
{
    NSSet *excludeProperties = [NSSet setWithObjects:@"rows", @"row", @"formController", @"propertyRows", @"sections", nil];
    NSSet *objectProperties = getNSObjectProperties();
    
    const char *propertyName = property_getName(property);
    *key = @(propertyName);
    // Ignore NSObject properties, unless overridden as readwrite
    char *readonly = property_copyAttributeValue(property, "R");
    if (nil != readonly)
    {
        free(readonly);
        if ([objectProperties containsObject:*key] || [excludeProperties containsObject:*key])
        {
            return NO;
        }
    }
    if ([excludeProperties containsObject:*key])
    {
        return NO;
    }
    
    // Get property type according to type encode --> https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
    // Then predicate the type of this cell
    Class valueClass = nil;
    NSString *valueType = nil;
    char *typeEncoding = property_copyAttributeValue(property, "T");
    switch (typeEncoding[0]) {
        case '@':
        {   // NSObject
            if(strlen(typeEncoding) >= 3)
            {   // Get ClassName
                char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                __autoreleasing NSString *name = @(className);
                NSRange range = [name rangeOfString:@"<"];
                if(range.location != NSNotFound)
                {
                    name = [name substringFromIndex:range.location];
                }
                valueClass = XEFormClassFromString(name) ? : [NSObject class];
                free(className);
            }
        }
            break;
        case 'B':
        {   // bool value
            valueClass = [NSNumber class];
            valueType = XEFormRowTypeBoolean;
        }
            break;
        case 'i':   // int
        case 's':   // short
        case 'l':   // longl
        case 'q':   // long long
        {
            valueClass = [NSNumber class];
            valueType = XEFormRowTypeInteger;
        }
            break;
        case 'I':   // unsigned int
        case 'S':   // unsigned short
        case 'L':   // unsigned long
        case 'Q':   // unsigned long long
        {
            valueClass = [NSNumber class];
            valueType = XEFormRowTypeUnsigned;
        }
            break;
        case 'f':   // float
        case 'd':   // double
        {
            valueClass = [NSNumber class];
            valueType = XEFormRowTypeFloat;
        }
            break;
        case '{':   // struct
        case '(':   // union
        {
            valueClass = [NSValue class];
            valueType = XEFormRowTypeLabel;
        }
            break;
            /** Don't process now*/
        case 'c':   // char
        case 'C':   // char *
        case '[':   // array
        case ':':   // selector
        case '#':   // class
        default:
        {
            valueClass = nil;
            valueType = nil;
        }
            break;
    }
    free(typeEncoding);
    *rowValueClass = valueClass;
    *type = valueType;
    return YES;
}

BOOL isDifferentString(NSString *str1, NSString *str2)
{
    if(str1)
    {
        if(str2)
        {
            return ![str1 isEqualToString:str2];
        }
        else
        {
            return YES;
        }
    }
    else
    {
        if(str2)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}
