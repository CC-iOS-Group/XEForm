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

@property (nonatomic, strong) UISwitch *switchControl;

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
    UIImage *switchOnImage = [self imageWithObject: [self.row.cellConfig objectForKey:@"switchOnImage"]];
    if (switchOnImage) [self.switchControl setOnImage:switchOnImage];
    UIImage *switchOffImage = [self imageWithObject: [self.row.cellConfig objectForKey:@"switchOffImage"]];
    if (switchOffImage) [self.switchControl setOffImage:switchOffImage];
    
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

- (UIImage *)imageWithObject:(id)imageObject
{
    UIImage *image;
    if(imageObject == nil)
    {
        image = nil;
    }
    else if ([imageObject isKindOfClass:[NSString class]])
    {
        image = [UIImage imageNamed:imageObject];
    }
    else if([imageObject isKindOfClass:[UIImage class]])
    {
        image = imageObject;
    }
    return image;
}

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
