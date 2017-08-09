//
//  SimpleForm3.m
//  XEForm
//
//  Created by 丁明 on 2017/8/2.
//  Copyright © 2017年 xenobladeX. All rights reserved.
//

#import "SimpleForm3.h"

#import <XEForm/XEFormRowObject.h>

@implementation SimpleForm3

- (void)testRow:(XEFormRowObject *)testRow
{
    testRow.title = nil;
    testRow.valueTransformer = ^id(id input) {
        return nil;
    };
}

@end
