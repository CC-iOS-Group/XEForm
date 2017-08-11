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
    secondFormRow.title = @"额吉佛陪请问胡椒粉i偶尔我就烦颇多撒娇佛安师大";
    secondFormRow.logoStr = @"https://avatars3.githubusercontent.com/u/8864284?v=4&s=40";
    secondFormRow.valueTransformer = ^id(id input) {
        return @"fsgfdadfabgfsdbfdbfsbafdbdfsbdfsbaef";
    };
}

- (void)secondForm2Row:(XEFormRowObject *)secondFormRow
{
    secondFormRow.valueTransformer = ^id(id input) {
        return @"二级菜单";
    };
}

- (void)textInputRow:(XEFormRowObject *)textInputRow
{
    XETextInputForm *textInputForm = [[XETextInputForm alloc] init];
    textInputForm.text = @"xenoblade";
    textInputRow.value = textInputForm;
}

- (void)textInlineRow:(XEFormRowObject *)textInlineRow
{
    textInlineRow.value = @"默认值";
    textInlineRow.placeholder = @"请输入";
}

@end
