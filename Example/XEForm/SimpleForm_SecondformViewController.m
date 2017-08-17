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
        // Data
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // UI
    self.title = @"二级菜单";
    
    // Data
    self.formController.form.rows = @[@"test"];
    
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

-(void)willChangeRow:(XEFormRowObject *)row newValue:(id)newValue source:(XEFormValueChangeSource)source success:(void (^)(void))successBlock failure:(void (^)(void))failureBlock
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        failureBlock();
    });
}

@end
