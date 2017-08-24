//
//  SimpleForm_SubtextviewViewController.m
//  XEForm
//
//  Created by 丁明 on 2017/8/16.
//  Copyright © 2017年 xenobladeX. All rights reserved.
//

#import "SimpleForm_SubtextviewViewController.h"

#import <XEForm/XEForm.h>

#import "XEFormDemoUtils.h"

@interface SimpleForm_SubtextviewViewController ()
{
    UIBarButtonItem *_rightItem;
}

@end

@implementation SimpleForm_SubtextviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(tapSaveButton)];
    _rightItem.enabled = NO;
    [self.navigationItem setRightBarButtonItem:_rightItem];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if(cell)
    {
        [cell becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  Action handle

- (void)tapSaveButton
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if([cell isKindOfClass: [XEFormTextViewCell class]])
    {
        XEFormTextViewCell *textFieldCell = (XEFormTextViewCell *)cell;
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
