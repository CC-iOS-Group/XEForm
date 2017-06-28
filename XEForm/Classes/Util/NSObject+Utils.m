//
//  NSObject+Utils.m
//  Pods
//
//  Created by 丁明 on 2017/6/28.
//
//

#import "NSObject+Utils.h"

@implementation NSObject(Utils)

- (NSString *)rowDescription
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
                NSString *description = [object rowDescription];
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

@end
