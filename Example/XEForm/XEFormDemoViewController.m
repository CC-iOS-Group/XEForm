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
    
    
}

- (IBAction)formButtonClicked:(UIButton *)sender {
    
    SimpleForm *form = [[SimpleForm alloc] init];
    
    XEFormRowObject *about = [[XEFormRowObject alloc] initWithKey:@"about" Class:[NSString class] type:XEFormRowTypeLongText];
    about.placeholder = @"something";
    
    XEFormRowObject *intValue = [[XEFormRowObject alloc] initWithKey:@"intValue" Class:[NSNumber class] type:XEFormRowTypeInteger];
    intValue.cellClass = NSClassFromString(@"XEFormStepperCell");
    
    XEFormRowObject *plan = [[XEFormRowObject alloc] initWithKey:@"plan" Class:[NSString class] type:XEFormRowTypeText];
    plan.options = @[@"Micro", @"Normal", @"Maxi"];
    plan.cellClass = NSClassFromString(@"XEFormOptionPickerCell");
    
    // TODO: Is it suitable to set second form rows here?
    form.secondForm.rows = @[@"test", @"gender", @"interests", @"test2"];
    
    form.rows = @[@"enable", @"username", @"password", about, @"hasLogin", @"birthday", intValue, @"image", plan, @"secondForm"];
    
    
    XEFormViewController *rootViewController = [form formViewController];
    [self.navigationController pushViewController:rootViewController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
