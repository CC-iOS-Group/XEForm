//
//  XEFormStepperCell.m
//  Pods
//
//  Created by 丁明 on 2017/7/4.
//
//

#import "XEFormStepperCell.h"

#import "XEFormConst.h"
#import "XEFormRowObject.h"

@implementation XEFormStepperCell

-(void)setUp
{
    UIView *wrapper = [[UIView alloc] initWithFrame:self.stepper.frame];
    [wrapper addSubview:self.stepper];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        wrapper.frame = CGRectMake(0, 0, wrapper.frame.size.width + XEFormRowPaddingRight, wrapper.frame.size.height);
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryView = wrapper;
}

- (void)update
{
    self.textLabel.text = self.row.title;
    self.textLabel.accessibilityValue = self.textLabel.text;
    NSString *desciption = [self.row rowDescription];
    if (nil == desciption)
    {
        if ([self.row.type isEqualToString:XEFormRowTypeFloat])
        {
            desciption = @"0.";
        }
        else
        {
            desciption = @"0";
        }
    }
    self.detailTextLabel.text = desciption;
    self.detailTextLabel.accessibilityValue = self.detailTextLabel.text;
    self.stepper.value = [self.row.value doubleValue];
}

#pragma mark - Action handle

- (void)valueChanged
{
    self.row.value = @(self.stepper.value);
    self.detailTextLabel.text = [self.row rowDescription];
    self.detailTextLabel.accessibilityValue = self.detailTextLabel.text;
    [self setNeedsLayout];
    
//    if (self.row.action)
//    {
//        self.row.action(self);
//    }
}

#pragma mark - Getter & setter

-(UIStepper *)stepper
{
    if (nil == _stepper)
    {
        _stepper = [[UIStepper alloc] init];
        _stepper.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_stepper addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _stepper;
}

@end
