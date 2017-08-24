//
//  SimpleForm_TextinputViewController.m
//  XEForm
//
//  Created by 丁明 on 2017/8/9.
//  Copyright © 2017年 xenobladeX. All rights reserved.
//

#import "SimpleForm_TextinputViewController.h"

#import <XEForm/XEForm.h>

#import "XEFormDemoUtils.h"

@interface SimpleForm_TextinputViewController ()
{
    UIBarButtonItem *_rightItem;
}
@end

@implementation SimpleForm_TextinputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    XETextInputForm *form = (XETextInputForm *)self.formController.form;
    XEFormRowObject *rowObject = form.textRow;
    rowObject.header = @"这是抬头";
    rowObject.footer = @"这是收尾";
    
    form.rows = @[@"text"];
    
    _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(tapSaveButton)];
    _rightItem.enabled = NO;
    [self.navigationItem setRightBarButtonItem:_rightItem];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -  Action handle

- (void)tapSaveButton
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if([cell isKindOfClass: [XEFormTextFieldCell class]])
    {
        XEFormTextFieldCell *textFieldCell = (XEFormTextFieldCell *)cell;
        [textFieldCell updateRowValueFromOther];
    }
}

#pragma mark - XEFormRowCellDelegate

-(void)willChangeRow:(XEFormRowObject *)row newValue:(id)newValue source:(XEFormValueChangeSource)source completion:(void (^)(NSError *))completionBlock
{
    switch (source) {
        case XEFormValueChangeSource_Edit:
        {
            if(isDifferentString(row.value, newValue))
            {
                _rightItem.enabled = YES;
            }
            else
            {
                _rightItem.enabled = NO;
            }
            
            completionBlock([NSError errorWithDomain:@"XEForm.com" code:0 userInfo:nil]);
        }
            break;
        case XEFormValueChangeSource_Save:
        {
            completionBlock(nil);
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}

@end
