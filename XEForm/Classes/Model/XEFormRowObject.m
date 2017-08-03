//
//  XEFormRowObject.m
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import "XEFormRowObject.h"

#import "XEFormUtils.h"
#import "XEFormController.h"
#import "NSObject+Utils.h"
#import "XEFormSetting.h"

@interface XEFormRowObject ()

@property (nonatomic, copy, readwrite) NSString *key;

@end

@implementation XEFormRowObject

@synthesize isSortable = _isSortable, value = _value;

-(instancetype)init
{
    
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Public method -

+(instancetype)objectWithProperty:(objc_property_t)property
{
    NSString *key, *type;
    Class class;
    if(XEFormRowObjectValueWithProperty(property, &key, &class, &type))
    {
        XEFormRowObject *rowObject = [[XEFormRowObject alloc] initWithKey:key Class:class type:type];
        return rowObject;
    }
    else
    {
        return nil;
    }
}

- (instancetype)initWithKey:(NSString *)key Class:(Class)class type:(NSString *)type
{
    if(key == nil)
    {
        [NSException raise:XEFormsException format:@"Key of XEFormRowObject can't be nil"];
    }
    if (self = [super init])
    {
        self.key = key;
        self.valueClass = class;
        self.type = type;
    }
    return self;
}

- (void)configWithForm:(XEForm *)form
{
    self.form = form;
    if (nil == self.cellConfig)
    {
        if([form respondsToSelector:@selector(row)])
        {
            self.cellConfig = ((XEFormRowObject *)[form row]).cellConfig;
        }
        else
        {
            self.cellConfig = [NSMutableDictionary dictionary];
        }
    }
    
    if ((self.options || self.viewController) &&
        ![self.type isEqualToString:XEFormRowTypeBitfield] &&
        !self.isInline)
    {
        //TODO: is there a good way to support custom type for non-inline options cells?
        //TODO: is there a better way to force non-inline cells to use base cell?
        self.type = XEFormRowTypeDefault;
    }
    
    // Get row value class
    if (nil == self.valueClass)
    {
        [self XEFormRowInferClass];
    }
    
    // Get default value
    if (self.defaultValue)
    {
        //workaround for common mistake where type is collection, but default value is a single value
        if ([self.valueClass isSubclassOfClass:[NSArray class]] &&
            ![self.defaultValue isKindOfClass:[NSArray class]])
        {
            self.defaultValue = [self.valueClass arrayWithObject:self.defaultValue];
        }
        else if([self.valueClass isSubclassOfClass:[NSSet class]] &&
                ![self.defaultValue isKindOfClass:[NSSet class]])
        {
            self.defaultValue = [self.valueClass setWithObject:self.defaultValue];
        }
        else if([self.valueClass isSubclassOfClass:[NSOrderedSet class]] &&
                ![self.defaultValue isKindOfClass:[NSOrderedSet class]])
        {
            self.defaultValue = [self.valueClass orderedSetWithObject:self.defaultValue];
        }
    }
    
    // Get row type
    if (nil == self.type)
    {
        self.type = [self XEFormRowInferType];
    }
    
    // Convert view controller from string to class
    if ([self.viewController isKindOfClass:[NSString class]])
    {
        self.viewController = XEFormClassFromString(self.viewController);
    }
    
    // Convert header from string to class
    if ([self.header isKindOfClass:[NSString class]])
    {
        Class viewClass = XEFormClassFromString(self.header);
        if ([viewClass isSubclassOfClass:[UIView class]])
        {
            self.header = viewClass;
        }
        else
        {
            
        }
    }
    else if ([self.header isKindOfClass:[NSNull class]])
    {
        self.header = @"";
    }
    
    // Convert footer from string to class
    if ([self.footer isKindOfClass:[NSString class]])
    {
        Class viewClass = XEFormClassFromString(self.footer);
        if ([viewClass isSubclassOfClass:[UIView class]])
        {
            self.footer = viewClass;
        }
        else
        {
            
        }
    }
    else if ([self.footer isKindOfClass:[NSNull class]])
    {
        self.footer = @"";
    }
    
    // Derive title from key or selector name
    if (nil == self.title)
    {
        BOOL wasCapital = YES;
        NSString *key = self.key;
        NSMutableString *output = nil;
        if (key)
        {
            output = [NSMutableString stringWithString:[[key substringToIndex:1] uppercaseString]];
            for (NSUInteger j = 1; j < [key length]; j++)
            {
                unichar character = [key characterAtIndex:j];
                BOOL isCapital = ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:character]);
                if (isCapital && !wasCapital) [output appendString:@" "];
                wasCapital = isCapital;
                if (character != ':') [output appendFormat:@"%C", character];
            }
        }
        if ([output length])
        {
            self.title = NSLocalizedString(output, nil);
        }
    }
}

- (NSString *)rowDescription
{
    if (self.options)
    {
        if ([self isIndexedType])
        {
            if (self.value)
            {
                return [self optionDescriptionAtIndex:[self.value integerValue] + (self.placeholder? 1: 0)];
            }
            else
            {
                return [self.placeholder rowDescription];
            }
        }
        
        if ([self isCollectionType])
        {
            id value = self.value;
            if ([value isKindOfClass:[NSIndexSet class]])
            {
                NSMutableArray *options = [NSMutableArray array];
                [self.options enumerateObjectsUsingBlock:^(id option, NSUInteger i, __unused BOOL *stop) {
                    NSUInteger index = i;
                    if ([option isKindOfClass:[NSNumber class]])
                    {
                        index = [option integerValue];
                    }
                    if ([value containsIndex:index])
                    {
                        NSString *description = [self optionDescriptionAtIndex:i + (self.placeholder? 1: 0)];
                        if ([description length]) [options addObject:description];
                    }
                }];
                
                value = [options count]? options: nil;
            }
            else if (value && self.valueTransformer)
            {
                NSMutableArray *options = [NSMutableArray array];
                for (id option in value) {
                    [options addObject:self.valueTransformer(option)];
                }
                value = [options count]? options: nil;
            }
            
            return [value rowDescription] ?: [self.placeholder rowDescription];
        }
        else if ([self.type isEqual:XEFormRowTypeBitfield])
        {
            NSUInteger value = [self.value integerValue];
            NSMutableArray *options = [NSMutableArray array];
            [self.options enumerateObjectsUsingBlock:^(id option, NSUInteger i, __unused BOOL *stop) {
                NSUInteger bit = 1 << i;
                if ([option isKindOfClass:[NSNumber class]])
                {
                    bit = [option integerValue];
                }
                if (value & bit)
                {
                    NSString *description = [self optionDescriptionAtIndex:i + (self.placeholder? 1: 0)];
                    if ([description length]) [options addObject:description];
                }
            }];
            
            return [options count]? [options rowDescription]: [self.placeholder rowDescription];
        }
        else if (self.placeholder && ![self.options containsObject:self.value])
        {
            return [self.placeholder description];
        }
    }
    
    return [self valueDescription:self.value];
}

-(NSAttributedString *)attributedTitle
{
    NSString *title = self.title;
    if (title)
    {
        return [[NSAttributedString alloc] initWithString:title attributes:[XEFormSetting sharedSetting].cellSetting.titleAttributes];
    }
    else
    {
        return nil;
    }
}

-(NSAttributedString *)attributedDescription
{
    NSString *description = self.rowDescription;
    if (description)
    {
        return [[NSAttributedString alloc] initWithString:description attributes:[XEFormSetting sharedSetting].cellSetting.descriptionAttributes];
    }
    else
    {
        return nil;
    }
}

- (BOOL)isIndexedType
{
    //return YES if value should be set as index of option, not value of option
    if ([self.valueClass isSubclassOfClass:[NSNumber class]] && ![self.type isEqualToString:XEFormRowTypeBitfield])
    {
        return ![[self.options firstObject] isKindOfClass:[NSNumber class]];
    }
    return NO;
}

- (BOOL)isCollectionType
{
    for (Class valueClass in @[[NSArray class], [NSSet class], [NSOrderedSet class], [NSIndexSet class], [NSDictionary class]])
    {
        if ([self.valueClass isSubclassOfClass:valueClass])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isOrderedCollectionType
{
    for (Class valueClass in @[[NSArray class], [NSOrderedSet class], [NSIndexSet class]])
    {
        if ([self.valueClass isSubclassOfClass:valueClass])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isSubform
{
    return (![self.type isEqualToString:XEFormRowTypeLabel] &&
            ([self.valueClass isSubclassOfClass:[XEForm class]] ||
             [self.valueClass isSubclassOfClass:[UIViewController class]] ||
             self.options || [self isCollectionType] || self.viewController));
}

#pragma mark Options

-(NSUInteger)optionCount
{
    NSUInteger count = [self.options count];
    return count? count + (self.placeholder? 1: 0): 0;
}

- (id)optionAtIndex:(NSUInteger)index
{
    if (index == 0)
    {
        return self.placeholder ?: self.options[0];
    }
    else
    {
        return self.options[index - (self.placeholder? 1: 0)];
    }
}

- (NSUInteger)indexOfOption:(id)option
{
    NSUInteger index = [self.options indexOfObject:option];
    if (index == NSNotFound)
    {
        return self.placeholder? 0: NSNotFound;
    }
    else
    {
        return index + (self.placeholder? 1: 0);
    }
}

- (NSString *)optionDescriptionAtIndex:(NSUInteger)index
{
    if (index == 0)
    {
        return self.placeholder? [self.placeholder rowDescription]: [self valueDescription:self.options[0]];
    }
    else
    {
        return [self valueDescription:self.options[index - (self.placeholder? 1: 0)]];
    }
}

- (void)setOptionSelected:(BOOL)selected atIndex:(NSUInteger)index
{
    if (self.placeholder)
    {
        index = (index == 0)? NSNotFound: index - 1;
    }
    
    if ([self isCollectionType])
    {
        BOOL copyNeeded = ([NSStringFromClass(self.valueClass) rangeOfString:@"Mutable"].location == NSNotFound);
        
        id collection = self.value ?: [[self.valueClass alloc] init];
        if (copyNeeded) collection = [collection mutableCopy];
        
        if (index == NSNotFound)
        {
            collection = nil;
        }
        else if ([self.valueClass isSubclassOfClass:[NSIndexSet class]])
        {
            if (selected)
            {
                [collection addIndex:index];
            }
            else
            {
                [collection removeIndex:index];
            }
        }
        else if ([self.valueClass isSubclassOfClass:[NSDictionary class]])
        {
            if (selected)
            {
                collection[@(index)] = self.options[index];
            }
            else
            {
                [(NSMutableDictionary *)collection removeObjectForKey:@(index)];
            }
        }
        else
        {
            //need to preserve order for ordered collections
            [collection removeAllObjects];
            [self.options enumerateObjectsUsingBlock:^(id option, NSUInteger i, __unused BOOL *stop) {
                
                if (i == index)
                {
                    if (selected) [collection addObject:option];
                }
                else if ([self.value containsObject:option])
                {
                    [collection addObject:option];
                }
            }];
        }
        
        if (copyNeeded) collection = [collection copy];
        self.value = collection;
    }
    else if ([self.type isEqualToString:XEFormRowTypeBitfield])
    {
        if (index == NSNotFound)
        {
            self.value = @0;
        }
        else
        {
            if ([self.options[index] isKindOfClass:[NSNumber class]])
            {
                index = [self.options[index] integerValue];
            }
            else
            {
                index = 1 << index;
            }
            if (selected)
            {
                self.value = @([self.value integerValue] | index);
            }
            else
            {
                self.value = @([self.value integerValue] ^ index);
            }
        }
    }
    else if ([self isIndexedType])
    {
        if (selected)
        {
            self.value = @(index);
        }
        //cannot deselect
    }
    else if (index != NSNotFound)
    {
        if (selected)
        {
            self.value = self.options[index];
        }
        //cannot deselect
    }
    else
    {
        self.value = nil;
    }
}

- (BOOL)isOptionSelectedAtIndex:(NSUInteger)index
{
    if (self.placeholder)
    {
        index = (index == 0)? NSNotFound: index - 1;
    }
    
    id option = (index == NSNotFound)? nil: self.options[index];
    if ([self isCollectionType])
    {
        if (index == NSNotFound)
        {
            //true if no option selected
            return [(NSArray *)self.value count] == 0;
        }
        else if ([self.valueClass isSubclassOfClass:[NSIndexSet class]])
        {
            if ([option isKindOfClass:[NSNumber class]])
            {
                index = [option integerValue];
            }
            return [(NSIndexSet *)self.value containsIndex:index];
        }
        else
        {
            return [(NSArray *)self.value containsObject:option];
        }
    }
    else if ([self.type isEqualToString:XEFormRowTypeBitfield])
    {
        if (index == NSNotFound)
        {
            //true if not numeric
            return ![self.value integerValue];
        }
        else if ([option isKindOfClass:[NSNumber class]])
        {
            index = [option integerValue];
        }
        else
        {
            index = 1 << index;
        }
        return ([self.value integerValue] & index) != 0;
    }
    else if ([self isIndexedType])
    {
        return self.value? [self.value unsignedIntegerValue] == index: !option;
    }
    else
    {
        return option? [option isEqual:self.value]: !self.value;
    }
}

- (Class)subViewControllerClass
{
    if ([self isSubform])
    {
        XEFormRowObject *row = self;
        NSString *rowPath = @"";
        XEForm *form;
        while (row)
        {
            
            rowPath = [NSString stringWithFormat:@"_%@%@", [row.key capitalizedString], rowPath];
            form = row.form;
            row = row.form.row;
        }
        
        if (rowPath.length > 0)
        {
            NSString *className = [NSString stringWithFormat:@"%@%@ViewController", NSStringFromClass([form class]), rowPath];
            Class subControlloerClass = NSClassFromString(className);
            if (subControlloerClass == nil)
            {
                // create class through runtime
                subControlloerClass = objc_allocateClassPair(NSClassFromString(@"XEFormViewController"), [className UTF8String], 0);
            }
            return subControlloerClass;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

#pragma mark - Private method

- (NSString *)XEFormRowInferType
{
    //guess type from class
    if ([self.valueClass isSubclassOfClass:[NSURL class]])
    {
        return XEFormRowTypeURL;
    }
    else if ([self.valueClass isSubclassOfClass:[NSNumber class]])
    {
        return XEFormRowTypeNumber;
    }
    else if ([self.valueClass isSubclassOfClass:[NSDate class]])
    {
        return XEFormRowTypeDate;
    }
    else if ([self.valueClass isSubclassOfClass:[UIImage class]])
    {
        return XEFormRowTypeImage;
    }
    
    if (!self.valueClass && ! self.action && !self.segue)
    {
        //assume string if there's no action and nothing else to go on
        self.valueClass = [NSString class];
    }
    
    //guess type from key name
    if ([self.valueClass isSubclassOfClass:[NSString class]])
    {
        NSString *lowercaseKey = [self.key lowercaseString];
        if ([lowercaseKey hasSuffix:@"password"])
        {
            return XEFormRowTypePassword;
        }
        else if ([lowercaseKey hasSuffix:@"email"] || [lowercaseKey hasSuffix:@"emailaddress"])
        {
            return XEFormRowTypeEmail;
        }
        else if ([lowercaseKey hasSuffix:@"phone"] || [lowercaseKey hasSuffix:@"phonenumber"])
        {
            return XEFormRowTypePhone;
        }
        else if ([lowercaseKey hasSuffix:@"url"] || [lowercaseKey hasSuffix:@"link"])
        {
            return XEFormRowTypeURL;
        }
        else if (self.valueClass)
        {
            //only return text type if there's no action and no better guess
            return XEFormRowTypeText;
        }
    }
    
    return XEFormRowTypeDefault;
}

- (Class) XEFormRowInferClass
{
    //if there are options, type should match first option
    if (self.options.count)
    {
        //use same type as options
        return [[self.options firstObject] classForCoder];
    }
    
    //attempt to determine class from type
    NSString *type = self.type ? : [self XEFormRowInferType];
    return @{
             XEFormRowTypeLabel: [NSString class],
             XEFormRowTypeText: [NSString class],
             XEFormRowTypeLongText: [NSString class],
             XEFormRowTypeURL: [NSURL class],
             XEFormRowTypeEmail: [NSString class],
             XEFormRowTypePhone: [NSString class],
             XEFormRowTypePassword: [NSString class],
             XEFormRowTypeNumber: [NSNumber class],
             XEFormRowTypeInteger: [NSNumber class],
             XEFormRowTypeUnsigned: [NSNumber class],
             XEFormRowTypeFloat: [NSNumber class],
             XEFormRowTypeBitfield: [NSNumber class],
             XEFormRowTypeBoolean: [NSNumber class],
             XEFormRowTypeOption: [NSNumber class],
             XEFormRowTypeDate: [NSDate class],
             XEFormRowTypeTime: [NSDate class],
             XEFormRowTypeDateTime: [NSDate class],
             XEFormRowTypeImage: [UIImage class]
             }[type];
}

- (NSString *)valueDescription:(id)value
{
    if (self.valueTransformer)
    {
        return [self.valueTransformer(value) rowDescription];
    }
    
    if ([value isKindOfClass:[NSDate class]])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if ([self.type isEqualToString:XEFormRowTypeDate])
        {
            formatter.dateStyle = NSDateFormatterMediumStyle;
            formatter.timeStyle = NSDateFormatterNoStyle;
        }
        else if ([self.type isEqualToString:XEFormRowTypeTime])
        {
            formatter.dateStyle = NSDateFormatterNoStyle;
            formatter.timeStyle = NSDateFormatterMediumStyle;
        }
        else //datetime
        {
            formatter.dateStyle = NSDateFormatterShortStyle;
            formatter.timeStyle = NSDateFormatterShortStyle;
        }
        
        return [formatter stringFromDate:value];
    }
    
    return [value rowDescription];
}

#pragma mark - Getter & setter

- (id)valueForUndefinedKey:(NSString *)key
{
    return [self.cellConfig objectForKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [_cellConfig setObject:value forKey:key];
}

- (id)valueWithoutDefaultSubstitution
{
    if (self.form && [self.form canGetValueForKey:self.key])
    {
        id value = [self.form valueForKey:self.key];
        if(value && self.options)
        {
            if ([self isIndexedType])
            {
                if ([value unsignedIntegerValue] >= [self.options count])
                {
                    value = nil;
                }
            }
            else if( ![self isCollectionType] && ![self.type isEqualToString:XEFormRowTypeBitfield])
            {
                if(![self.options containsObject:value])
                {
                    value = nil;
                }
            }
        }
        return value;
    }
    return nil;
}

-(id)value
{
    if ([self.form canGetValueForKey: self.key])
    {   // Property
        id value = [self.form valueForKey:self.key];
        if(value && self.options)
        {
            if([self isIndexedType])
            {
                if([value unsignedIntegerValue] >= self.options.count)
                {
                    value = nil;
                }
            }
            else if(![self isCollectionType] && ![self.type isEqualToString:XEFormRowTypeBitfield])
            {
                if([self.options containsObject:value])
                {
                    value = nil;
                }
            }
        }
        if(!value && self.defaultValue)
        {
            self.value = value = self.defaultValue;
        }
        return value;
    }
    else
    {
        // extra
        if(nil == _value)
        {
            return self.defaultValue;
        }
        else
        {
            return _value;
        }
    }
}

-(void)setValue:(id)value
{
    _value = value;
    if (self.form && [self.form canSetValueForKey:self.key])
    {
        value = value ? : self.defaultValue;
        
        if(self.reverseValueTransformer && ![self isCollectionType] && !self.options)
        {
            value = self.reverseValueTransformer(value);
        }
        // set NSString
        else if([value isKindOfClass:[NSString class]])
        {
            if([self.type isEqualToString:XEFormRowTypeNumber] ||
               [self.type isEqualToString:XEFormRowTypeFloat])
            {
                value = [(NSString *)value length]? @([value doubleValue]): nil;
            }
            else if ([self.type isEqualToString:XEFormRowTypeInteger] ||
                     [self.type isEqualToString:XEFormRowTypeUnsigned])
            {
                value = [(NSString *)value length]? @([value longLongValue]): nil;
            }
            else if ([self.valueClass isSubclassOfClass:[NSURL class]])
            {
                value = [self.valueClass URLWithString:value];
            }
        }
        // set to NSString
        else if ([self.valueClass isSubclassOfClass:[NSString class]])
        {
            //handle case where value is numeric but value class is string
            value = [value description];
        }
        
        if (self.valueClass == [NSMutableString class])
        {
            //replace string or make mutable copy of it
            id __value = [self valueWithoutDefaultSubstitution];
            if (__value)
            {
                [(NSMutableString *)__value setString:value];
                value = __value;
            }
            else
            {
                value = [NSMutableString stringWithString:value];
            }
        }
        
        if (!value)
        {
            for (XEFormRowObject *row in self.form.propertyRows)
            {
                if ([row.key isEqualToString:self.key])
                {
                    if ([@[XEFormRowTypeBoolean, XEFormRowTypeInteger,
                           XEFormRowTypeUnsigned, XEFormRowTypeFloat] containsObject:row.type])
                    {
                        //prevents NSInvalidArgumentException in setNilValueForKey: method
                        value = [self isIndexedType]? @(NSNotFound): @0;
                    }
                    break;
                }
            }
        }
        
        [self.form setValue:value forKey:self.key];
    }
}

- (void)setValueTransformer:(id)valueTransformer
{
    if ([valueTransformer isKindOfClass:[NSString class]])
    {
        valueTransformer = XEFormClassFromString(valueTransformer);
    }
    if ([valueTransformer class] == valueTransformer)
    {
        valueTransformer = [[valueTransformer alloc] init];
    }
    if ([valueTransformer isKindOfClass:[NSValueTransformer class]])
    {
        NSValueTransformer *transformer = valueTransformer;
        valueTransformer = ^(id input)
        {
            return [transformer transformedValue:input];
        };
        if ([[transformer class] allowsReverseTransformation])
        {
            _reverseValueTransformer = ^(id input)
            {
                return [transformer reverseTransformedValue:input];
            };
        }
    }
    
    _valueTransformer = [valueTransformer copy];
}

-(void)setAction:(id)action
{
    if ([action isKindOfClass:[NSString class]])
    {
        SEL selector = NSSelectorFromString(action);
        __weak XEFormRowObject *weakSelf = self;
        action = ^(id sender)
        {
            [weakSelf.form.formController performAction:selector withSender:sender];
        };
    }
    
    _action = [action copy];
}

-(void)setSegue:(id)segue
{
    if ([segue isKindOfClass:[NSString class]])
    {
        segue = XEFormClassFromString(segue) ? : [segue copy];
    }
    NSAssert(segue != [UIStoryboardPopoverSegue class], @"Unfortunately displaying subcontrollers using UIStoryboardPopoverSegue is not supported, as doing so would require calling private methods. To display using a popover, create a custom UIStoryboard subclass instead.");
    
    _segue = segue;
}

-(void)setValueClass:(Class)valueClass
{
    _valueClass = valueClass;
}

-(void)setCellClass:(Class)cellClass
{
    _cellClass = cellClass;
}

-(void)setDefaultValue:(id)defaultValue
{
    _defaultValue = defaultValue;
}

-(void)setIsInline:(BOOL)isInline
{
    _isInline = isInline;
}

-(void)setOptions:(NSArray *)options
{
    _options = [options count] ? [options copy] : nil;
}

-(void)setIsSortable:(BOOL)isSortable
{
    _isSortable = isSortable;
}

-(void)setHeader:(id)header
{
    if ([header class] == header)
    {
        header = [[header alloc] init];
    }
    _header = header;
}

-(void)setFooter:(id)footer
{
    if ([footer class] == footer)
    {
        footer = [[footer alloc] init];
    }
    _footer = footer;
}

-(BOOL)isSortable
{
    return _isSortable && ([self.valueClass isSubclassOfClass:[NSArray class]] || [self.valueClass isSubclassOfClass:[NSOrderedSet class]]);
}

@end
