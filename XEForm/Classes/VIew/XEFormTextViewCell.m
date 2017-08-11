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

@interface XEFormTextViewCell ()<UITextViewDelegate>

@end

@implementation XEFormTextViewCell


-(void)dealloc
{
    self.textView.delegate = nil;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect labelFrame = self.textLabel.frame;
    labelFrame.origin.y = XEFormRowPaddingTop;
    labelFrame.size.width =  MIN(MAX([self.textLabel sizeThatFits:CGSizeZero].width, XEFormRowMinLabelWidth), XEFormRowMaxLabelWidth);
    labelFrame.size.height = 21.;
    self.textLabel.frame = labelFrame;
    
    CGRect textViewFrame = self.textView.frame;
    textViewFrame.origin.x = XEFormRowPaddingLeft;
    textViewFrame.origin.y = self.textLabel.frame.origin.y + self.textLabel.frame.size.height;
    textViewFrame.size.width = self.contentView.bounds.size.width - XEFormRowPaddingLeft - XEFormRowPaddingRight;
    CGSize textViewSize = [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, FLT_MAX)];
    textViewFrame.size.height = ceilf(textViewSize.height);
    if (self.textLabel.text.length == 0)
    {
        textViewFrame.origin.y = self.textLabel.frame.origin.y;
    }
    self.textView.frame = textViewFrame;
    
    self.placeholder.frame = CGRectMake(5, 0, textViewFrame.size.width - 5, textViewFrame.size.height);
    
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.size.height = self.textView.frame.origin.y + self.textView.frame.size.height + XEFormRowPaddingBottom;
    self.contentView.frame = contentViewFrame;
}


#pragma mark - Customize

-(void)setUp
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleRightMargin;
    
    [self.contentView addSubview:self.textView];
    
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.textView action:NSSelectorFromString(@"becomeFirstResponder")]];
}

-(void)update
{
    self.textLabel.text = self.row.title;
    self.textLabel.accessibilityValue = self.textLabel.text;
    self.textView.text = [self.row rowDescription];
    self.placeholder.text = self.row.placeholder;
    self.placeholder.accessibilityValue = self.detailTextLabel.text;
    self.placeholder.hidden = self.textView.text.length > 0;
    
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
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.textView selectAll:nil];
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self updateRowValue];
    
    self.placeholder.hidden = textView.text.length > 0;
    
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    
    [tableView endUpdates];
    
    //scroll to show cursor
    CGRect cursorRect = [self.textView caretRectForPosition:self.textView.selectedTextRange.end];
    [tableView scrollRectToVisible:[tableView convertRect:cursorRect fromView:self.textView] animated:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self updateRowValue];
    
//    if (self.row.action)
//    {
//        self.row.action(self);
//    }
}

+(CGFloat)heightForRow:(XEFormRowObject *)row width:(CGFloat)width
{
    static UITextView *textView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textView = [[UITextView alloc] init];
        textView.font = [UIFont systemFontOfSize:XEFormDefaultFontSize];
    });
    
    textView.text = [row rowDescription] ? : @" ";
    CGSize textViewSize = [textView sizeThatFits:CGSizeMake(width - XEFormRowPaddingLeft - XEFormRowPaddingRight, FLT_MAX)];
    // TODO: label height
    CGFloat height = row.title.length ? 21 : 0;
    height += XEFormRowPaddingTop + ceilf(textViewSize.height) + XEFormRowPaddingBottom;
    return height;
}

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


#pragma mark - Private method

- (void)updateRowValue
{
    self.row.value = self.textView.text;
}

#pragma mark - Getter & setter

-(UITextView *)textView
{
    if (nil == _textView)
    {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 21)];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleRightMargin;
        _textView.font = [UIFont systemFontOfSize:XEFormDefaultFontSize];
        _textView.textColor = [UIColor colorWithRed:0.275 green:0.376 blue:0.522 alpha:1.000];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.scrollEnabled = NO;
        [_textView addSubview:self.placeholder];
    }
    return _textView;
}

-(UILabel *)placeholder
{
    if (nil == _placeholder)
    {
        _placeholder = [[UILabel alloc] init];
        _placeholder.textColor = [UIColor grayColor];
        _placeholder.textAlignment = NSTextAlignmentLeft;
        _placeholder.numberOfLines = 0;
    }
    return _placeholder;
}

@end
