//
//  SimpleForm_TextinputViewController.m
//  XEForm
//
//  Created by 丁明 on 2017/8/9.
//  Copyright © 2017年 xenobladeX. All rights reserved.
//

#import "SimpleForm_TextinputViewController.h"

#import <XEForm/XETextInputForm.h>
#import <XEForm/XEFormController.h>
#import <XEForm/XEFormRowObject.h>
#import <XEForm/XEFormTextFieldCell.h>

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
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell becomeFirstResponder];

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

-(void)willChangeRow:(XEFormRowObject *)row newValue:(id)newValue source:(XEFormValueChangeSource)source success:(void (^)(void))successBlock failure:(void (^)(void))failureBlock
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
            
            failureBlock();
        }
            break;
        case XEFormValueChangeSource_Save:
        {
            successBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}

BOOL isDifferentString(NSString *str1, NSString *str2)
{
    if(str1)
    {
        if(str2)
        {
            return ![str1 isEqualToString:str2];
        }
        else
        {
            return YES;
        }
    }
    else
    {
        if(str2)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

@end
