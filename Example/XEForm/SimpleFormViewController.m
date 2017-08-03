//
//  XEFormRootViewController.m
//  XEForm
//
//  Created by 丁明 on 2017/7/27.
//  Copyright © 2017年 xenobladeX. All rights reserved.
//

#import "SimpleFormViewController.h"

#import <XEForm/XEFormController.h>
#import <XEForm/XEFormRowObject.h>

@interface SimpleFormViewController ()

@end

@implementation SimpleFormViewController

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"一级菜单";

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)customizeFormTableView
{
    UITableView *formTableView =
    [[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                 style:UITableViewStyleGrouped];
    return formTableView;
}




@end
