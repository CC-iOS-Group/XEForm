//
//  XEFormHeaderFooterView.m
//  Pods
//
//  Created by 丁明 on 2017/7/28.
//
//

#import "XEFormHeaderFooterView.h"

#import "XEFormSetting.h"

@interface XEFormHeaderFooterView ()

@property (nonatomic, readwrite) CGSize viewSize;
// TODO: replace with UITextView, so we can implement tap
@property (nonatomic, strong) UIView<XEFormLabelDelegate> *textlabel;

@end



@implementation XEFormHeaderFooterView


-(instancetype)initWithTableWidth:(CGFloat)tableWidth text:(NSAttributedString *)text
{
    self = [super init];
    if (self)
    {
        self.viewSize = CGSizeMake(tableWidth, FLT_MAX);
        [self addSubview:self.textlabel];
        self.text = text;
    }
    return self;
}




-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.textlabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:[XEFormSetting sharedSetting].headerFooterViewSetting.edgeInsets.top];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.textlabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-[XEFormSetting sharedSetting].headerFooterViewSetting.edgeInsets.bottom];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.textlabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:[XEFormSetting sharedSetting].headerFooterViewSetting.edgeInsets.left];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.textlabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-[XEFormSetting sharedSetting].headerFooterViewSetting.edgeInsets.right];
    
    [self addConstraints: @[topConstraint, bottomConstraint, leftConstraint, rightConstraint]];
}

+(CGFloat)heightWithMaxWidth:(CGFloat)maxWidth Text:(NSAttributedString *)text
{
    if(text.length > 0)
    {
        UILabel *textlabel = [[UILabel alloc] init];
        textlabel.numberOfLines = 0;
        textlabel.attributedText = text;
        CGSize fitSize = [textlabel sizeThatFits:CGSizeMake(maxWidth - ([XEFormSetting sharedSetting].headerFooterViewSetting.edgeInsets.left + [XEFormSetting sharedSetting].headerFooterViewSetting.edgeInsets.right), FLT_MAX)];
        return fitSize.height + ([XEFormSetting sharedSetting].headerFooterViewSetting.edgeInsets.top + [XEFormSetting sharedSetting].headerFooterViewSetting.edgeInsets.bottom);
    }
    else
    {
        return ([XEFormSetting sharedSetting].headerFooterViewSetting.edgeInsets.top + [XEFormSetting sharedSetting].headerFooterViewSetting.edgeInsets.bottom);
    }
}



#pragma mark -  Getter & setter

-(UIView<XEFormLabelDelegate> *)textlabel
{
    if (nil == _textlabel)
    {
        Class XEFormLabel = [XEFormSetting sharedSetting].xeFormLabelClass;
        _textlabel = [[XEFormLabel alloc] init];
        _textlabel.translatesAutoresizingMaskIntoConstraints = NO;
        _textlabel.numberOfLines = 0;
    }
    return _textlabel;
}

-(void)setText:(NSAttributedString *)text
{
    _text = text;
    self.textlabel.attributedText = text;
    CGFloat height = [XEFormHeaderFooterView heightWithMaxWidth:self.viewSize.width - (([XEFormSetting sharedSetting].headerFooterViewSetting.edgeInsets.left + [XEFormSetting sharedSetting].headerFooterViewSetting.edgeInsets.right)) Text:text];
    self.viewSize = CGSizeMake(self.viewSize.width, height);
    // Set frame
    self.frame = CGRectMake(0, 0, self.viewSize.width, self.viewSize.height);
}

@end
