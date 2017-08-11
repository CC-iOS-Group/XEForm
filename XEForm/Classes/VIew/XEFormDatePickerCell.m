//
//  XEFormDatePickerCell.m
//  Pods
//
//  Created by 丁明 on 2017/7/4.
//
//

#import "XEFormDatePickerCell.h"

#import "XEFormConst.h"
#import "XEFormRowObject.h"

@implementation XEFormDatePickerCell

#pragma mark - Customize

-(void)setUp
{
//    
}

-(void)update
{
    self.textLabel.text = self.row.title;
    self.textLabel.accessibilityValue = self.textLabel.text;
    self.detailTextLabel.text = [self.row rowDescription] ? : [self.row.placeholder rowDescription];
    self.detailTextLabel.accessibilityValue = self.detailTextLabel.text;
    
    if ([self.row.type isEqualToString:XEFormRowTypeDate])
    {
        self.datePicker.datePickerMode = UIDatePickerModeDate;
    }
    else if ([self.row.type isEqualToString:XEFormRowTypeTime])
    {
        self.datePicker.datePickerMode = UIDatePickerModeTime;
    }
    else
    {
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    
    self.datePicker.date = self.row.value ? :
    [self.row.placeholder isKindOfClass:[NSDate class]] ? self.row.placeholder : [NSDate date];
}

-(UIView *)inputView
{
    return self.datePicker;
}

- (BOOL)canBecomeFirstResponder
{
    // TODO: handle datapicker show and hide
    return YES;
}

-(void)didSelectWithTableView:(UITableView *)tableView controller:(UIViewController *)controller
{
    if (![self isFirstResponder])
    {
        [self becomeFirstResponder];
    }
    else
    {
        [self resignFirstResponder];
    }
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

#pragma mark - Action handle

- (void)valueChanged
{
    self.row.value = self.datePicker.date;
    self.detailTextLabel.text = [self.row rowDescription];
    self.detailTextLabel.accessibilityValue = self.detailTextLabel.text;
    [self setNeedsLayout];
    
//    if (self.row.action)
//    {
//        self.row.action(self);
//    }
}

#pragma mark - Getter & setter

-(UIDatePicker *)datePicker
{
    if (nil == _datePicker)
    {
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

@end
