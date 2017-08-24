//
//  XEFormTextViewCell.m
//  Pods
//
//  Created by 丁明 on 2017/7/3.
//
//

#import "XEFormTextViewCell.h"
#import "XEFormRowObject.h"
#import "XEFormConst.h"
#import "XEFormSetting.h"

@interface XEFormTextView ()

@property (nonatomic, strong) UILabel *placeholder;

@end

@implementation XEFormTextView

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self addSubview:self.placeholder];
        
        CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
        UIEdgeInsets textContainerInset = self.textContainerInset;
        CGFloat x = lineFragmentPadding + textContainerInset.left;
        CGFloat y = textContainerInset.top;
        
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1. constant:y];
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1. constant:x];
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1. constant:-x];
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.placeholder attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1. constant:-(textContainerInset.top+textContainerInset.bottom)];
        [self addConstraints:@[topConstraint, leftConstraint, widthConstraint, heightConstraint]];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updatePlaceholderLabel)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    self.placeholder.hidden = self.text.length > 0;
}

- (void)updatePlaceholderLabel
{
    self.placeholder.hidden = self.text.length > 0;
}

-(UILabel *)placeholder
{
    if (nil == _placeholder)
    {
        _placeholder = [[UILabel alloc] init];
        _placeholder.translatesAutoresizingMaskIntoConstraints = NO;
        _placeholder.textColor = [UIColor lightGrayColor];
        _placeholder.textAlignment = self.textAlignment;
        _placeholder.numberOfLines = 0;
    }
    return _placeholder;
}


@end



@interface XEFormTextViewCell ()<UITextViewDelegate>
{
    NSLayoutConstraint *_textViewWidthConstraint;
}

@property (nonatomic, strong) UIView<XEFormLabelDelegate> *titleLabel;

@end

@implementation XEFormTextViewCell


-(void)dealloc
{
    self.textView.delegate = nil;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}


#pragma mark - Customize

-(void)setUp
{
    [super setUp];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.textView];
    
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.textView action:NSSelectorFromString(@"becomeFirstResponder")]];
    
    // AutoLayout
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1. constant:[XEFormSetting sharedSetting].cellSetting.offsetX];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1. constant:[XEFormSetting sharedSetting].cellSetting.offsetY];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.3 constant:0];
    [self.contentView addConstraints:@[leftConstraint, topConstraint, widthConstraint]];
    
    topConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1. constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-[XEFormSetting sharedSetting].cellSetting.offsetX];
     _textViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.7 constant:-[XEFormSetting sharedSetting].cellSetting.offsetX];
    [self.contentView addConstraints:@[topConstraint, bottomConstraint, rightConstraint, _textViewWidthConstraint]];
    
    
}

-(void)update
{
    self.titleLabel.attributedText = self.row.attributedTitle;
    self.titleLabel.accessibilityValue = self.titleLabel.text;
    self.textView.attributedText = self.row.rowDescription ? [[NSAttributedString alloc] initWithString:self.row.rowDescription attributes:[XEFormSetting sharedSetting].cellSetting.textViewAttributes] : nil;
    self.textView.placeholder.attributedText = self.row.placeholder ? [[NSAttributedString alloc] initWithString:self.row.placeholder attributes:[XEFormSetting sharedSetting].cellSetting.textViewAttributes] : nil;
    self.textView.placeholder.accessibilityValue = self.textView.placeholder.text;
    
    self.textView.returnKeyType = UIReturnKeyDefault;
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.secureTextEntry = NO;
    
    if ([self.row.type isEqualToString:XEFormRowTypeText])
    {
        self.textView.autocorrectionType = UITextAutocorrectionTypeDefault;
        self.textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        self.textView.keyboardType = UIKeyboardTypeDefault;
    }
    else if([self.row.type isEqualToString:XEFormRowTypeUnsigned])
    {
        self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textView.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([@[XEFormRowTypeNumber, XEFormRowTypeInteger, XEFormRowTypeFloat] containsObject:self.row.type])
    {
        self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    
    if(self.titleLabel.text.length == 0)
    {
        [self.contentView removeConstraint:_textViewWidthConstraint];
        _textViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-2*[XEFormSetting sharedSetting].cellSetting.offsetX];
        [self.contentView addConstraint:_textViewWidthConstraint];
    }
    else
    {
        [self.contentView removeConstraint:_textViewWidthConstraint];
        _textViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.7 constant:-[XEFormSetting sharedSetting].cellSetting.offsetX];
        [self.contentView addConstraint:_textViewWidthConstraint];
    }
    
    [super update];
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{

}

-(void)textViewDidChange:(UITextView *)textView
{
    self.textView.attributedText = textView.text ? [[NSAttributedString alloc] initWithString:textView.text attributes:[XEFormSetting sharedSetting].cellSetting.textViewAttributes] : nil;
    
//    UITableView *tableView = [self tableView];
//    [tableView beginUpdates];
//    
//    [tableView endUpdates];
//    
//    //scroll to show cursor
//    CGRect cursorRect = [self.textView caretRectForPosition:self.textView.selectedTextRange.end];
//    [tableView scrollRectToVisible:[tableView convertRect:cursorRect fromView:self.textView] animated:YES];
    
    if([self.delegate respondsToSelector:@selector(willChangeRow:newValue:source:completion:)])
    {
        __weak typeof(self) weak_self = self;
        
        [self.delegate willChangeRow:self.row newValue:self.textView.text source:XEFormValueChangeSource_Edit completion:^(NSError *error) {
            if(error)
            {
                
            }
            else
            {
                [weak_self updateRowValue];
            }
        }];
    }
    else
    {
        [self updateRowValue];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(![self.row.form isKindOfClass:NSClassFromString(@"XETextInputForm")])
    {
        if([self.delegate respondsToSelector:@selector(willChangeRow:newValue:source:completion:)])
        {
            __weak typeof(self) weak_self = self;
            
            [self.delegate willChangeRow:self.row newValue:self.textView.text source:XEFormValueChangeSource_Save completion:^(NSError *error) {
                if (error)
                {
                    
                }
                else
                {
                    [weak_self updateRowValue];
                }
            }];
        }
        else
        {
            [self updateRowValue];
        }
    }
    
}


//+(CGFloat)heightForRow:(XEFormRowObject *)row width:(CGFloat)width
//{
//    static UITextView *textView;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        textView = [[UITextView alloc] init];
//        textView.font = [UIFont systemFontOfSize:XEFormDefaultFontSize];
//    });
//    
//    textView.text = [row rowDescription] ? : @" ";
//    CGSize textViewSize = [textView sizeThatFits:CGSizeMake(width - XEFormRowPaddingLeft - XEFormRowPaddingRight, FLT_MAX)];

//    CGFloat height = row.title.length ? 21 : 0;
//    height += XEFormRowPaddingTop + ceilf(textViewSize.height) + XEFormRowPaddingBottom;
//    return height;
//}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [self.textView becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.textView resignFirstResponder];
}

-(void)updateRowValueFromOther
{
    if([self.delegate respondsToSelector:@selector(willChangeRow:newValue:source:completion:)])
    {
        __weak typeof(self) weak_self = self;
        
        [self.delegate willChangeRow:self.row newValue:self.textView.text source:XEFormValueChangeSource_Save completion:^(NSError *error) {
            if (error)
            {
                
            }
            else
            {
                [weak_self updateRowValue];
            }
        }];
    }
}

#pragma mark - Private method

- (void)updateRowValue
{
    self.row.value = self.textView.text;
}

#pragma mark - Getter & setter

-(XEFormTextView *)textView
{
    if (nil == _textView)
    {
        _textView = [[XEFormTextView alloc] init];
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.scrollEnabled = YES;
    }
    return _textView;
}

-(UIView<XEFormLabelDelegate> *)titleLabel
{
    if (nil == _titleLabel)
    {
        Class XEFormLabel = [XEFormSetting sharedSetting].xeFormLabelClass;
        _titleLabel = [[XEFormLabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    return _titleLabel;
}

@end
