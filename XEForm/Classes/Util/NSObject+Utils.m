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
    for (Class rowClass in @[[NSString class], [NSNumber class], [NSDate class]])
    {
        if ([self isKindOfClass:rowClass])
        {
            return [self description];
        }
    }
    for (Class rowClass in @[[NSDictionary class], [NSArray class], [NSSet class], [NSOrderedSet class]])
    {
        if ([self isKindOfClass:rowClass])
        {
            id collection = self;
            if (rowClass == [NSDictionary class])
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
    if([self isKindOfClass:NSClassFromString(@"XEForm")])
    {
        return nil;
    }
    return @"CAN'T RECOGNISE";
}

@end
