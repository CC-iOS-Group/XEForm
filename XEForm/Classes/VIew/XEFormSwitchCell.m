//
//  XEFormSwitchCell.m
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import "XEFormSwitchCell.h"

#import "XEFormRowObject.h"

@interface XEFormSwitchCell ()


@end

@implementation XEFormSwitchCell

-(void)setUp
{
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    self.accessoryView = self.switchControl;
}

-(void)update
{
    self.textLabel.text = self.row.title;
    self.textLabel.accessibilityValue = self.textLabel.text;
    self.switchControl.on = [self.row.value boolValue];
    
}

#pragma mark - Action handle

- (void)valueChanged
{
    self.row.value = @(self.switchControl.on);
    
    if (self.row.action)
    {
        self.row.action(self);
    }
}

#pragma mark - Private method



#pragma mark - Getter & setter

-(UISwitch *)switchControl
{
    if (nil == _switchControl)
    {
        _switchControl = [[UISwitch alloc] init];
        [_switchControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _switchControl;
}

@end
