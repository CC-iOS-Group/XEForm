//
//  XEFormTextFieldCell.m
//  Pods
//
//  Created by 丁明 on 2017/6/28.
//
//

#import "XEFormTextFieldCell.h"

#import "XEFormUtils.h"

@interface XEFormTextFieldCell ()<UITextFieldDelegate>


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
    
    CGRect labelFrame = self.textLabel.frame;
    labelFrame.size.width = MIN(MAX([self.textLabel sizeThatFits:CGSizeZero].width, XEFormRowMinLabelWidth), XEFormRowMaxLabelWidth);
    self.textLabel.frame = labelFrame;
    
    CGRect textFieldFrame = self.textField.frame;
    textFieldFrame.origin.x = self.textLabel.frame.origin.x + MAX(XEFormRowMinLabelWidth, self.textLabel.frame.size.width) + XEFormRowLabelSpacing;
    textFieldFrame.origin.y = (self.contentView.bounds.size.height - textFieldFrame.size.height) / 2;
    textFieldFrame.size.width = self.textField.superview.frame.size.width - textFieldFrame.origin.x - XEFormRowPaddingRight;
    if (![self.textLabel.text length])
    {
        textFieldFrame.origin.x = XEFormRowPaddingLeft;
        textFieldFrame.size.width = self.contentView.bounds.size.width - XEFormRowPaddingLeft - XEFormRowPaddingRight;
    }
    else if (self.textField.textAlignment == NSTextAlignmentRight)
    {
        textFieldFrame.origin.x = self.textLabel.frame.origin.x + labelFrame.size.width + XEFormRowLabelSpacing;
        textFieldFrame.size.width = self.textField.superview.frame.size.width - textFieldFrame.origin.x - XEFormRowPaddingRight;
    }
    self.textField.frame = textFieldFrame;
}

#pragma mark - Customize

-(void)setUp
{
    [super setUp];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 21)];
    self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleLeftMargin;
    self.textField.font = [UIFont systemFontOfSize:self.textLabel.font.pointSize];
    self.textField.minimumFontSize = XEFormLabelMinFontSize(self.textLabel);
    self.textField.textColor = [UIColor colorWithRed:0.275f green:0.376f blue:0.522f alpha:1.000f];
    self.textField.delegate = self;
    [self.contentView addSubview:self.textField];
    
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.textField action:NSSelectorFromString(@"becomeFirstResponder")]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:self.textField];
}

- (void)update
{
    [super update];
    
    self.textLabel.text = self.row.title;
    self.textLabel.accessibilityValue = self.textLabel.text;
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
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!self.returnKeyOverridden)
    {
        //get return key type
        UIReturnKeyType returnKeyType = UIReturnKeyDone;
        UITableViewCell <XEFormRowCellDelegate> *nextCell = self.nextCell;
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
    [self.textField selectAll:nil];
}

- (void)textDidChange
{
    [self updateRowValue];
}

- (BOOL)textFieldShouldReturn:(__unused UITextField *)textField
{
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
    [self updateRowValue];
    
    if (self.row.action) self.row.action(self);
}

- (void)updateRowValue
{
    self.row.value = self.textField.text;
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


@end
