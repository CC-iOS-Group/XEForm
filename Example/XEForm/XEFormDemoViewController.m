//
//  XEFormViewController.m
//  XEForm
//
//  Created by xenobladeX on 06/22/2017.
//  Copyright (c) 2017 xenobladeX. All rights reserved.
//

#import "XEFormDemoViewController.h"

#import "SimpleForm2.h"
#import <XEForm/XEFormController.h>
#import <XEForm/XEFormRowObject.h>
#import <XEForm/XEFormConst.h>

@interface XEFormDemoViewController ()

@end

@implementation XEFormDemoViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        SimpleForm2 *forms = [[SimpleForm2 alloc] init];
        XEFormRowObject *username = [[XEFormRowObject alloc] initWithKey:@"username" Class:[NSString class] type:XEFormRowTypeText];
        username.header = @"请输入用户名、密码";
        username.title = @"用户名";
        XEFormRowObject *password = [[XEFormRowObject alloc] initWithKey:@"password" Class:[NSString class] type:XEFormRowTypePassword];
        password.footer = @"注意";
        password.title= @"密码";
        forms.rows = @[username, password];
        self.formController.form = forms;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
