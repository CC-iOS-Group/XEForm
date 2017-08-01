//
//  SecondformViewController.m
//  XEForm
//
//  Created by 丁明 on 2017/7/28.
//  Copyright © 2017年 xenobladeX. All rights reserved.
//

#import "SimpleForm_SecondformViewController.h"

#import <XEForm/XEFormController.h>
#import <XEForm/XEFormRowObject.h>

@interface SimpleForm_SecondformViewController ()

@end

@implementation SimpleForm_SecondformViewController

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
    
    // UI
    self.title = @"二级菜单";
    
    // Data
    
    
}

-(void)viewDidLayoutSubviews
{
    
    self.tableView.frame = self.view.frame;
    
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
