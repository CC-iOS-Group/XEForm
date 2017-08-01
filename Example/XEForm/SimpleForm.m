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

- (void)enableRow:(XEFormRowObject *)enableRow
{
    
}

- (void)usernameRow:(XEFormRowObject *)usernameRow
{
    usernameRow.header = @"注意；打飞机扣篮大赛积分卡了；奥德赛狗儿清洁工vi企鹅哦【根据诶哦怕热刚进去弄去儿【价格v饿哦情人坡根据藕片认可岂容平稳开发工具曲谱大数据付了款；爱的";
    usernameRow.title = @"用户名";
    usernameRow.logoStr = @"https://avatars3.githubusercontent.com/u/8864284?v=3&s=40";
    usernameRow.defaultValue = @"hehe";
    usernameRow.cellClass = NSClassFromString(@"XEFormDefaultCell");
    usernameRow.cellConfig = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           [UIColor redColor], @"textLabel.color",
                           
                           nil];
}

- (void)passwordRow:(XEFormRowObject *)passwordRow
{
    passwordRow.footer = @"注意；打飞机扣篮大赛积分卡了；奥德赛狗儿清洁工vi企鹅哦【根据诶哦怕热刚进去弄去儿【价格v饿哦情人坡根据藕片认可岂容平稳开发工具曲谱大数据付了款；爱的世界佛i【EQ人感觉哦【二伏面我佩服苗侨伟破放进去围殴批发价【哦喷雾剂佛请问披肩发请问哦朋【呃我批发价饿哦平稳【感觉发起饿哦苹果【去饿哦喷雾剂佛喷雾剂佛牌【企鹅就无法破温泉街佛牌【耳机佛牌千而万加工品【额我家那个v而且哦i过节费企鹅我怕【就";
    passwordRow.title= @"密码";
}

@end
