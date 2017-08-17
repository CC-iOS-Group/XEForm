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
//    textInlineRow.value = @"默认值";
    textInlineRow.placeholder = @"请输入";
}

- (void)textViewRow:(XEFormRowObject *)textViewRow
{
    textViewRow.title = nil;
    textViewRow.type = XEFormRowTypeLongText;
    textViewRow.placeholder = @"Placeholder 大师级啊付了款；点撒就离开发；骄傲的看是否感觉阿卡；砥节奉公课啊我就烦刚看了；爱的枷锁发刻录机联发科；爱的枷锁卡乐付据鞍读书立刻放假啊鄂温克浪费精力；口味啊副经理库文件分类词库；撒DJ联发科；进度撒李开复解除了撒旦会计分录快点撒就发了看大家斯洛伐克；进度撒联发科；就离开适当放宽了；微积分零库存；焦恩俊擦伤看到了伐就离开；大家是否快乐；SD就离开；金额巧克力；我放假了开启违反纪律看；请问看起来放进去了；额我放假了可千万";
}

- (void)subTextViewRow:(XEFormRowObject *)subTextViewRow
{
    XETextInputForm *textInputForm = [[XETextInputForm alloc] init];
    textInputForm.text = @"大师级啊付了款；点撒就离开发；骄傲的看是否感觉阿卡；砥节奉公课啊我就烦刚看了；爱的枷锁发刻录机联发科；爱的枷锁卡乐付据鞍读书立刻放假啊鄂温克浪费精力；口味啊副经理库文件分类词库；撒DJ";
    textInputForm.type = XEFormRowTypeLongText;
    subTextViewRow.value = textInputForm;
}

@end
