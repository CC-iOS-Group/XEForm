//
//  XEFormViewController.m
//  XEForm
//
//  Created by xenobladeX on 06/22/2017.
//  Copyright (c) 2017 xenobladeX. All rights reserved.
//

#import "XEFormDemoViewController.h"

#import "SimpleForm.h"
#import <XEForm/XEFormController.h>
#import <XEForm/XEFormRowObject.h>
#import <XEForm/XEFormConst.h>

@interface XEFormDemoViewController ()

@end

@implementation XEFormDemoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"首页";
}

- (IBAction)formButtonClicked:(UIButton *)sender {
    
    SimpleForm *form = [[SimpleForm alloc] init];
    
    form.secondForm2.rows = @[@"test"];
    form.rows = @[@"secondForm", @"secondForm2", @"textInput", @"textInline"];
    
    
    XEFormViewController *rootViewController = [form formViewController];
    [self.navigationController pushViewController:rootViewController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
