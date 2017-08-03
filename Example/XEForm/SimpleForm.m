//
//  SimpleForm2.m
//  XEForm
//
//  Created by 丁明 on 2017/6/23.
//  Copyright © 2017年 xenobladeX. All rights reserved.
//

#import "SimpleForm.h"

#import <XEForm/XEFormRowObject.h>
#import <XEForm/XEFormConst.h>

@implementation SimpleForm


- (void)secondFormRow:(XEFormRowObject *)secondFormRow
{
    secondFormRow.valueTransformer = ^id(id input) {
        return @"二级菜单";
    };
}

- (void)secondForm2Row:(XEFormRowObject *)secondFormRow
{
    secondFormRow.valueTransformer = ^id(id input) {
        return @"二级菜单";
    };
}

@end
