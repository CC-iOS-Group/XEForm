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

static CGFloat kDefault_switchWidth = 51.;
static CGFloat kDefault_switchHeight = 31.;

@implementation XEFormSwitchCell

-(void)setUp
{
    [super setUp];
    
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    self.rowAccessoryView = self.switchControl;
}

-(void)update
{
    [super update];
    
    self.titleLabel.attributedText = self.row.attributedTitle;
    self.titleLabel.accessibilityValue = self.titleLabel.text;
    self.descriptionLabel.attributedText = self.row.attributedDescription;
    self.descriptionLabel.accessibilityValue = self.descriptionLabel.text;
    
    self.switchControl.on = [self.row.value boolValue];
    
}

#pragma mark - Action handle

- (void)valueChanged
{
    XEFormRowObject *row = self.row;
    row.value = @(self.switchControl.on);
    self.row = row;
    
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
        _switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, kDefault_switchWidth, kDefault_switchHeight)];
        [_switchControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _switchControl;
}

@end
