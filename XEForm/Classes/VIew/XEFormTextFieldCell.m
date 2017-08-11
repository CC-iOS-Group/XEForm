//
//  XEFormTextFieldCell.m
//  Pods
//
//  Created by 丁明 on 2017/6/28.
//
//

#import "XEFormTextFieldCell.h"

#import "XEFormUtils.h"
#import "XEFormSetting.h"

@interface XEFormTextFieldCell ()<UITextFieldDelegate>
{
    NSLayoutConstraint *_textFieldWidthConstraint;
}

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign, getter = isReturnKeyOverriden) BOOL returnKeyOverridden;

@end

@implementation XEFormTextFieldCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _textField.delegate = nil;
}

-(void)setValue:(id)value forKeyPath:(NSString *)keyPath
{
    if ([keyPath isEqualToString:@"textField.returnKeyType"])
    {
        //oh god, the hack, it burns
        self.returnKeyOverridden = YES;
    }
    
    [super setValue:value forKeyPath:keyPath];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

#pragma mark - Customize

-(void)setUp
{
    [super setUp];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.textField];
    
    // auto layout
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:[XEFormSetting sharedSetting].cellSetting.offsetX];
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.3 constant:0];
    [self.contentView addConstraints:@[leftConstraint, centerYConstraint, widthConstraint]];
    
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-[XEFormSetting sharedSetting].cellSetting.offsetX];
    _textFieldWidthConstraint = [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.7 constant:-[XEFormSetting sharedSetting].cellSetting.offsetX];
    [self.contentView addConstraints:@[topConstraint, bottomConstraint, rightConstraint, _textFieldWidthConstraint]];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.textField action:NSSelectorFromString(@"becomeFirstResponder")]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.textField];
}

- (void)update
{
    self.titleLabel.attributedText = self.row.attributedTitle;
    self.titleLabel.accessibilityValue = self.titleLabel.text;
    
    self.textField.placeholder = [self.row.placeholder rowDescription];
    self.textField.text = [self.row rowDescription];
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.textAlignment = [self.row.title length]? NSTextAlignmentRight: NSTextAlignmentLeft;
    self.textField.secureTextEntry = NO;
    
    if ([self.row.type isEqualToString:XEFormRowTypeText])
    {
        self.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        self.textField.keyboardType = UIKeyboardTypeDefault;
    }
    else if ([self.row.type isEqualToString:XEFormRowTypeUnsigned])
    {
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.textAlignment = NSTextAlignmentRight;
    }
    else if ([@[XEFormRowTypeNumber, XEFormRowTypeInteger, XEFormRowTypeFloat] containsObject:self.row.type])
    {
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.textField.textAlignment = NSTextAlignmentRight;
    }
    else if ([self.row.type isEqualToString:XEFormRowTypePassword])
    {
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.keyboardType = UIKeyboardTypeDefault;
        self.textField.secureTextEntry = YES;
    }
    else if ([self.row.type isEqualToString:XEFormRowTypeEmail])
    {
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else if ([self.row.type isEqualToString:XEFormRowTypePhone])
    {
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.keyboardType = UIKeyboardTypePhonePad;
    }
    else if ([self.row.type isEqualToString:XEFormRowTypeURL])
    {
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.keyboardType = UIKeyboardTypeURL;
    }
    
    if(!self.titleLabel.text)
    {
        [self.contentView removeConstraint:_textFieldWidthConstraint];
        _textFieldWidthConstraint = [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-2*[XEFormSetting sharedSetting].cellSetting.offsetX];
        [self.contentView addConstraint:_textFieldWidthConstraint];
    }
    else
    {
        [self.contentView removeConstraint:_textFieldWidthConstraint];
        _textFieldWidthConstraint = [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.7 constant:-[XEFormSetting sharedSetting].cellSetting.offsetX];
        [self.contentView addConstraint:_textFieldWidthConstraint];
    }
    
    [super update];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!self.returnKeyOverridden)
    {
        //get return key type
        UIReturnKeyType returnKeyType = UIReturnKeyDone;
        XEFormBaseCell *nextCell = self.nextCell;
        if ([nextCell canBecomeFirstResponder])
        {
            returnKeyType = UIReturnKeyNext;
        }
        
        self.textField.returnKeyType = returnKeyType;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(__unused UITextField *)textField
{
    
}

- (void)textDidChange
{
    if([self.delegate respondsToSelector:@selector(willChangeRow:newValue:source:success:failure:)])
    {
        __weak typeof(self) weak_self = self;
        [self.delegate willChangeRow:self.row newValue:self.textField.text source:XEFormValueChangeSource_Edit success:^{
            [weak_self updateRowValue];
        } failure:^{
            
        }];
    }
    else
    {
        [self updateRowValue];
    }
}

- (BOOL)textFieldShouldReturn:(__unused UITextField *)textField
{
    if(isDifferentString(self.row.value, self.textField.text))
    {
        if([self.delegate respondsToSelector:@selector(willChangeRow:newValue:source:success:failure:)])
        {
            __weak typeof(self) weak_self = self;
            [self.delegate willChangeRow:self.row newValue:self.textField.text source:XEFormValueChangeSource_Save success:^{
                [weak_self updateRowValue];
            } failure:^{
                
            }];
        }
        else
        {
            [self updateRowValue];
        }
    }
    
    if (self.textField.returnKeyType == UIReturnKeyNext)
    {
        [self.nextCell becomeFirstResponder];
    }
    else
    {
        [self.textField resignFirstResponder];
    }
    
    return NO;
}

- (void)textFieldDidEndEditing:(__unused UITextField *)textField
{
    if(![self.row.form isKindOfClass:NSClassFromString(@"XETextInputForm")])
    {
        [self update];
    }
}

- (void)updateRowValue
{
    self.row.value = self.textField.text;
}

-(void)updateRowValueFromOther
{
    if(isDifferentString(self.row.value, self.textField.text))
    {
        if([self.delegate respondsToSelector:@selector(willChangeRow:newValue:source:success:failure:)])
        {
            __weak typeof(self) weak_self = self;
            [self.delegate willChangeRow:self.row newValue:self.textField.text source:XEFormValueChangeSource_Save success:^{
                [weak_self updateRowValue];
            } failure:^{
                
            }];
        }
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.textField resignFirstResponder];
}

#pragma mark - Getter & setter

-(UILabel *)titleLabel
{
    if (nil == _titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        
    }
    return _titleLabel;
}

-(UITextField *)textField
{
    if (nil == _textField)
    {
        _textField = [[UITextField alloc] init];
        _textField.translatesAutoresizingMaskIntoConstraints = NO;
        _textField.font = [XEFormSetting sharedSetting].cellSetting.textInputFont;
        _textField.textColor = [XEFormSetting sharedSetting].cellSetting.textInputTextColor;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.delegate = self;
    }
    return _textField;
    
}


@end
