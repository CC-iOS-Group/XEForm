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

- (void)usernameRow:(XEFormRowObject *)usernameRow
{
    usernameRow.header = @"请输入用户名、密码";
    usernameRow.title = @"用户名";
    usernameRow.logoStr = @"https://avatars3.githubusercontent.com/u/8864284?v=3&s=40";
    usernameRow.cellConfig = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           [UIColor redColor], @"textLabel.color",
                           
                           nil];
}

- (void)passwordRow:(XEFormRowObject *)passwordRow
{
    passwordRow.footer = @"注意";
    passwordRow.title= @"密码";
}

@end
