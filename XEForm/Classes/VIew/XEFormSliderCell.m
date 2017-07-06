//
//  XEFormSliderCell.m
//  Pods
//
//  Created by 丁明 on 2017/7/4.
//
//

#import "XEFormSliderCell.h"

#import "XEFormConst.h"
#import "XEFormRowObject.h"

@implementation XEFormSliderCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect sliderFrame = self.slider.frame;
    sliderFrame.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + XEFormRowPaddingLeft;
    sliderFrame.origin.y = (self.contentView.frame.size.height - sliderFrame.size.height) / 2;
    sliderFrame.size.width = self.contentView.bounds.size.width - sliderFrame.origin.x - XEFormRowPaddingRight;
    self.slider.frame = sliderFrame;
}

#pragma mark - Customize

-(void)setUp
{
    [self.contentView addSubview:self.slider];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)update
{
    self.textLabel.text = self.row.title;
    self.textLabel.accessibilityValue = self.textLabel.text;
    self.slider.value = [self.row.value doubleValue];
}

#pragma mark - Action handle

- (void)valueChanged
{
    self.row.value = @(self.slider.value);
    
    if (self.row.action)
    {
        self.row.action(self);
    }
}

#pragma mark - Slider

-(UISlider *)slider
{
    if (nil == _slider)
    {
        _slider = [[UISlider alloc] init];
        [_slider addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
        
    }
    return _slider;
}

@end
