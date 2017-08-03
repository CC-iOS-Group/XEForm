//
//  SimpleForm.m
//  XEForm
//
//  Created by 丁明 on 2017/6/23.
//  Copyright © 2017年 xenobladeX. All rights reserved.
//

#import "SimpleForm2.h"

#import <XEForm/XEFormRowObject.h>
#import <XEForm/XEFormConst.h>
#import <XEForm/XEFormBaseCell.h>

@implementation SimpleForm2

- (void)testRow:(XEFormRowObject *)testRow
{
    testRow.title = @"呵呵";
    testRow.action = ^(id sender) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            XEFormBaseCell *cell = (XEFormBaseCell *)sender;
            cell.row.value = @(![cell.row.value boolValue]);
            cell.row = cell.row;
        });
    };

    
    
}

@end
