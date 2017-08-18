//
//  SimpleForm.m
//  XEForm
//
//  Created by 丁明 on 2017/6/23.
//  Copyright © 2017年 xenobladeX. All rights reserved.
//

#import "SimpleForm2.h"

@implementation SimpleForm2

- (void)testRow:(XEFormRowObject *)testRow
{
    testRow.title = @"布尔值";
    testRow.valueTransformer = ^id(NSNumber *value) {
        if (value.boolValue)
        {
            return @"已启用";
        }
        else
        {
            return @"未启用";
        }
    };
}

@end
