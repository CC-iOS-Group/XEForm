//
//  XEFormSwitchCell.m
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import "XEFormSwitchCell.h"

#import "XEFormRowObject.h"
#import "XEFormSetting.h"

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
    self.switchControl.on = [self.row.value boolValue];

    [super update];
}

#pragma mark - Action handle

- (void)valueChanged
{
    if ([self.delegate respondsToSelector:@selector(willChangeRow:newValue:source:success:failure:)])
    {
        // UI change
        
        NSString *description = [self.row valueDescription:@(self.switchControl.on)];
        if (description)
        {
            NSAttributedString *attributedDescription = [[NSAttributedString alloc] initWithString:description attributes:[XEFormSetting sharedSetting].cellSetting.descriptionAttributes];
            self.descriptionLabel.attributedText = attributedDescription;
        }
        else
        {
            self.descriptionLabel.attributedText = nil;
        }

        __weak typeof(self) weak_self = self;
        self.switchControl.userInteractionEnabled = NO;
        [self.delegate willChangeRow:self.row newValue:@(self.switchControl.on) source:XEFormValueChangeSource_Edit success:^{
            weak_self.switchControl.userInteractionEnabled = YES;
            weak_self.row.value = @(weak_self.switchControl.on);
            
            [weak_self update];
        } failure:^{
            weak_self.switchControl.userInteractionEnabled = YES;
            weak_self.switchControl.on = !weak_self.switchControl.on;
            
            [weak_self update];
        }];
    }
    else
    {
        self.row.value = @(self.switchControl.on);
        [self update];
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
