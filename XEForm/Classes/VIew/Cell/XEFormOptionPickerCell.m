//
//  XEFormOptionPickerCell.m
//  Pods
//
//  Created by 丁明 on 2017/7/6.
//
//

#import "XEFormOptionPickerCell.h"

#import "XEFormConst.h"
#import "XEFormRowObject.h"

@interface XEFormOptionPickerCell () <UIPickerViewDataSource, UIPickerViewDelegate>



@end

@implementation XEFormOptionPickerCell

-(void)setUp
{
    
}

-(void)dealloc
{
    _pickerView.dataSource = nil;
    _pickerView.delegate = nil;
}

-(void)update
{
    self.textLabel.text = self.row.title;
    self.textLabel.accessibilityValue = self.textLabel.text;
    self.detailTextLabel.text = [self.row rowDescription];
    self.detailTextLabel.accessibilityValue = self.detailTextLabel.text;
    
    NSUInteger index = self.row.value ? [self.row.options indexOfObject:self.row.value] : NSNotFound;
    if (self.row.placeholder)
    {
        index = (index == NSNotFound) ? 0 : index + 1;
    }
    if (index != NSNotFound)
    {
        [self.pickerView selectRow:index inComponent:0 animated:NO];
    }
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(UIView *)inputView
{
    return self.pickerView;
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


#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.row optionCount];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.row optionDescriptionAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.row setOptionSelected:YES atIndex:row];
    self.detailTextLabel.text = [self.row rowDescription] ? : [self.row.placeholder rowDescription];
    self.detailTextLabel.accessibilityValue = self.detailTextLabel.text;
    
    [self setNeedsLayout];
    
    if (self.row.action)
    {
        self.row.action(self, ^{
            
        }, ^(NSError *error) {
            
        });
    }
}

#pragma mark - Getter & setter

-(UIPickerView *)pickerView
{
    if (nil == _pickerView)
    {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

@end
