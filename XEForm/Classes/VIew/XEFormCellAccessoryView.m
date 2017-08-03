//
//  XEFormCellAccessoryView.m
//  Pods
//
//  Created by 丁明 on 2017/8/3.
//
//

#import "XEFormCellAccessoryView.h"

#import "XEFormSetting.h"

@interface XEFormCellAccessoryView ()
{
    NSLayoutConstraint *_centerXConstraint;
    NSLayoutConstraint *_centerYConstraint;
}

@property (nonatomic, assign, readwrite) CGFloat accessoryViewWidth;


@end

@implementation XEFormCellAccessoryView

-(void)layoutSubviews
{
    [super layoutSubviews];

}


-(void)setContentView:(UIView *)contentView
{
    if (_contentView)
    {
        [self removeConstraints:@[_centerXConstraint, _centerYConstraint]];
        [_contentView removeFromSuperview];
    }
    _contentView = contentView;
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if(_contentView)
    {
        _accessoryViewWidth = _contentView.frame.size.width + 2*[XEFormSetting sharedSetting].cellSetting.offsetX;
        [self addSubview:_contentView];
        _centerXConstraint = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1. constant:0];
        _centerYConstraint = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1. constant:0];
        [self addConstraints:@[_centerXConstraint, _centerYConstraint]];
    }
    else
    {
        
    }
}

@end
