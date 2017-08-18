//
//  XEFormViewController.m
//  XEForm
//
//  Created by xenobladeX on 06/22/2017.
//  Copyright (c) 2017 xenobladeX. All rights reserved.
//

#import "XEFormDemoViewController.h"

#import <XEForm/XEFormController.h>
#import <XEForm/XEFormRowObject.h>
#import <XEForm/XEFormConst.h>

#import "SimpleFormViewController.h"

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
    
    SimpleFormViewController *rootViewController = [[SimpleFormViewController alloc] init];
    [self.navigationController pushViewController:rootViewController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
