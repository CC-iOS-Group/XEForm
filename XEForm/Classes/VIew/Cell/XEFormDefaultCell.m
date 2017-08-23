//
//  XEFormDefaultCell.m
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import "XEFormDefaultCell.h"

#import "XEFormRowObject.h"
#import "XEFormConst.h"
#import "XEFormUtils.h"
#import "XEFormRowViewControllerDelegate.h"
#import "XEFormViewController.h"
#import "XEFormSetting.h"
#import "UIView+XEForm.h"


@interface XEFormDefaultCell ()
{
    CGFloat _rowAccessoryViewWidth;
    UIView *_rowAccessoryContentView;
    
    // AutoLayouts
    NSLayoutConstraint *_rowAccessoryViewWidthConstraint;
    
    NSLayoutConstraint *_accessoryContentViewLeftConstraint;
    NSLayoutConstraint *_accessoryContentViewcenterYConstraint;
    NSLayoutConstraint *_accessoryContentViewWidthConstraint;
    
    NSLayoutConstraint *_logoViewWidthConstraint;
    NSLayoutConstraint *_titleLabelLeftConstraint;
    NSLayoutConstraint *_titleLabelWidthConstraint;
    NSLayoutConstraint *_descriptionLabelRightConstraint;
    
}

@end

@implementation XEFormDefaultCell

@synthesize rowAccessoryView = _rowAccessoryView;

-(void)setUp
{
    [super setUp];
    
    [self addSubview:self.rowContentView];
    [self addSubview:self.rowAccessoryView];
    
    // rowAccessoryView
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.rowAccessoryView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.rowAccessoryView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.rowAccessoryView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    _rowAccessoryViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.rowAccessoryView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_rowAccessoryViewWidth];
    [self addConstraints: @[topConstraint, rightConstraint, bottomConstraint, _rowAccessoryViewWidthConstraint]];
    
    // Row content view
    topConstraint = [NSLayoutConstraint constraintWithItem:self.rowContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    rightConstraint = [NSLayoutConstraint constraintWithItem:self.rowContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.rowAccessoryView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-0];
    bottomConstraint = [NSLayoutConstraint constraintWithItem:self.rowContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.rowContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self addConstraints:@[topConstraint, rightConstraint, bottomConstraint, leftConstraint]];
    
    // Row Logo View
    leftConstraint = [NSLayoutConstraint constraintWithItem:self.rowLogoView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.rowContentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:[XEFormSetting sharedSetting].cellSetting.offsetX];
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.rowLogoView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.rowContentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.rowLogoView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1. constant:[XEFormSetting sharedSetting].cellSetting.logoPlaceholder.size.height];
    _logoViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.rowLogoView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1. constant:[XEFormSetting sharedSetting].cellSetting.logoPlaceholder.size.width];
    [self addConstraints:@[leftConstraint, centerYConstraint, _logoViewWidthConstraint, heightConstraint]];
    
    // Title Label
    centerYConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.rowContentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    _titleLabelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.rowContentView attribute:NSLayoutAttributeWidth multiplier:0.6 constant:-[XEFormSetting sharedSetting].cellSetting.offsetX];
    _titleLabelLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.rowLogoView attribute:NSLayoutAttributeRight multiplier:1.0 constant:[XEFormSetting sharedSetting].cellSetting.offsetX];
    [self addConstraints:@[centerYConstraint,  _titleLabelLeftConstraint, _titleLabelWidthConstraint]];
    
    // Description Label
    centerYConstraint = [NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.rowContentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    leftConstraint = [NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.titleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:[XEFormSetting sharedSetting].cellSetting.offsetX];
    _descriptionLabelRightConstraint = [NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.rowContentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-[XEFormSetting sharedSetting].cellSetting.offsetX];
    [self addConstraints:@[centerYConstraint, _descriptionLabelRightConstraint,leftConstraint]];
}

-(void)update
{
    
    self.titleLabel.attributedText = self.row.attributedTitle;
    self.titleLabel.accessibilityValue = self.titleLabel.text;
    self.descriptionLabel.attributedText = self.row.attributedDescription;
    self.descriptionLabel.accessibilityValue = self.descriptionLabel.text;

    if ([self.row.type isEqualToString:XEFormRowTypeLabel])
    {
        self.rowAccessoryType = UITableViewCellAccessoryNone;
        if (nil == self.row.action)
        {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    else if([self.row isSubform] || self.row.segue)
    {
        self.rowAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if([self.row.type isEqualToString:XEFormRowTypeBoolean] ||
            [self.row.type isEqualToString:XEFormRowTypeOption])
    {
        if(![[self class] isSubclassOfClass:[XEFormDefaultCell class]])
        {
            self.descriptionLabel.attributedText = nil;
            self.descriptionLabel.accessibilityValue = self.descriptionLabel.text;
            self.rowAccessoryType = [self.row.value boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }
    }
    else if([self.row.type isEqualToString:XEFormRowTypeText])
    {
        self.rowAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(self.row.action)
    {
        self.descriptionLabel = UITableViewCellAccessoryNone;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        self.rowAccessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Update layout
    if (self.row.logoStr)
    {
        _logoViewWidthConstraint.constant = [XEFormSetting sharedSetting].cellSetting.logoPlaceholder.size.width;
        _titleLabelLeftConstraint.constant = [XEFormSetting sharedSetting].cellSetting.offsetX;
        NSURL *logoUrl = [NSURL URLWithString:self.row.logoStr];
        if (logoUrl)
        {
            if (logoUrl.host)
            {
                [[XEFormSetting sharedSetting].delegagte setImageView:self.rowLogoView withURL:logoUrl placeholder:[XEFormSetting sharedSetting].cellSetting.logoPlaceholder];
//                [self.rowLogoView setImageWithURL:logoUrl placeholder:[XEFormSetting sharedSetting].cellSetting.logoPlaceholder];
//                [self.imageView setImageWithURL:logoUrl placeholder:[XEFormSetting sharedSetting].cellSetting.logoPlaceholder];
            }
            else if ([logoUrl isFileURL])
            {
                UIImage *logo = [UIImage imageWithContentsOfFile:logoUrl.absoluteString];
                [self.imageView setImage: (logo ? : [XEFormSetting sharedSetting].cellSetting.logoPlaceholder)];
            }
            else
            {
                UIImage *logo = [UIImage imageNamed:self.row.logoStr];
                [self.imageView setImage: (logo ? : [XEFormSetting sharedSetting].cellSetting.logoPlaceholder)];
            }
        }
    }
    else
    {
        _logoViewWidthConstraint.constant = 0;
        _titleLabelLeftConstraint.constant = 0;
    }
    
    if(self.row.rowDescription)
    {
        _descriptionLabelRightConstraint.constant = -[XEFormSetting sharedSetting].cellSetting.offsetX;
        
    }
    else
    {
        _descriptionLabelRightConstraint.constant = 0;
    }
    
    [super update];
}


-(void)didSelectWithTableView:(UITableView *)tableView controller:(UIViewController *)controller
{
    if([self.row.type isEqualToString:XEFormRowTypeBoolean] ||
       [self.row.type isEqualToString:XEFormRowTypeOption])
    {
        [[tableView findFirstResponder] resignFirstResponder];
        self.row.value = @(![self.row.value boolValue]);
        if (self.row.action)
        {
            self.row.action(self, ^{
                
            }, ^(NSError *error) {
                
            });
        }
        if(![[self class] isSubclassOfClass:[XEFormDefaultCell class]])
        {
            self.rowAccessoryType = [self.row.value boolValue] ? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
        }
        if ([self.row.type isEqualToString:XEFormRowTypeOption])
        {
            NSIndexPath *indexPath = [tableView indexPathForCell:self];
            if (indexPath)
            {
                // Reload section, in case fields are linked
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
        else
        {
            // Deselect the cell
            [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
        }
    }
    else if (self.row.action && (![self.row isSubform] || !self.row.options))
    {
        [[tableView findFirstResponder] resignFirstResponder];
        self.row.action(self, ^{
            
        }, ^(NSError *error) {
            
        });
        [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    }
    else if(self.row.segue && [self.row.segue class] != self.row.segue)
    {
        [[tableView findFirstResponder] resignFirstResponder];
        if ([self.row.segue isKindOfClass:[UIStoryboardSegue class]])
        {
            [controller prepareForSegue:self.row.segue sender:self];
            [(UIStoryboardSegue *)self.row.segue perform];
        }
        else if ([self.row.segue isKindOfClass:[NSString class]])
        {
            [controller performSegueWithIdentifier:self.row.segue sender:self];
        }
    }
    else if ([self.row isSubform])
    {
        [[tableView findFirstResponder] resignFirstResponder];
        UIViewController *subcontroller = nil;
        if ([self.row.valueClass isSubclassOfClass:[UIViewController class]])
        {
            subcontroller = self.row.value ? : [[self.row.valueClass class] init];
        }
        else if(self.row.viewController && self.row.viewController == [self.row.viewController class])
        {
            subcontroller = [[self.row.viewController alloc] init];
            ((id <XEFormRowViewControllerDelegate>)subcontroller).row = self.row;
        }
        else if ([self.row.viewController isKindOfClass:[UIViewController class]])
        {
            subcontroller = self.row.viewController;
            ((id <XEFormRowViewControllerDelegate>)subcontroller).row = self.row;
        }
        else
        {
            if(self.row.viewController)
            {
                subcontroller = self.row.viewController;
            }
            else
            {
                Class subViewControllerClass = self.row.subViewControllerClass;
                if (subViewControllerClass)
                {
                    subcontroller = [[[self.row subViewControllerClass] alloc] init];
                }
                else
                {
                    return;
                }
            }
            ((id <XEFormRowViewControllerDelegate>)subcontroller).row = self.row;
        }
        if (!subcontroller.title)
        {
            subcontroller.title = self.row.title;
        }
        if (self.row.segue)
        {
            UIStoryboardSegue *segue = [[self.row.segue alloc] initWithIdentifier:self.row.key source:controller destination:subcontroller];
            [controller prepareForSegue:self.row.segue sender:self];
            [segue perform];
        }
        else
        {
            NSAssert(controller.navigationController != nil, @"Attempted to push a sub-viewController from a form that is not embedded inside a UINavigationController. That won't work!");
            [controller.navigationController pushViewController:subcontroller animated:YES];
        }
    }
}

#pragma mark - Getter & setter

-(UIImageView *)rowLogoView
{
    if (nil == _rowLogoView)
    {
        _rowLogoView = [[UIImageView alloc] init];
        _rowLogoView.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    return _rowLogoView;
}

-(UIView *)rowContentView
{
    if (nil == _rowContentView)
    {
        _rowContentView = [[UIView alloc] init];
        _rowContentView.translatesAutoresizingMaskIntoConstraints = NO;
        [_rowContentView addSubview:self.rowLogoView];
        [_rowContentView addSubview:self.titleLabel];
        [_rowContentView addSubview:self.descriptionLabel];
    }
    return _rowContentView;
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

-(UIView<XEFormLabelDelegate> *)descriptionLabel
{
    if (nil == _descriptionLabel)
    {
        Class XEFormLabel = [XEFormSetting sharedSetting].xeFormLabelClass;
        _descriptionLabel = [[XEFormLabel alloc] init];
        _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    return _descriptionLabel;
}

-(UIView *)rowAccessoryView
{
    if (nil == _rowAccessoryView)
    {
        _rowAccessoryView = [[UIView alloc] init];
        _rowAccessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _rowAccessoryView;
}

-(void)setRowAccessoryView:(UIView *)rowAccessoryView
{
    if (_rowAccessoryContentView)
    {
        [self removeConstraints:@[_accessoryContentViewLeftConstraint, _accessoryContentViewcenterYConstraint, _accessoryContentViewWidthConstraint]];
        [_rowAccessoryContentView removeFromSuperview];
    }
    _rowAccessoryContentView = rowAccessoryView;
    _rowAccessoryContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if(_rowAccessoryContentView)
    {
        _rowAccessoryViewWidth = _rowAccessoryContentView.frame.size.width + [XEFormSetting sharedSetting].cellSetting.offsetX;
        [self.rowAccessoryView addSubview:_rowAccessoryContentView];
        _accessoryContentViewLeftConstraint = [NSLayoutConstraint constraintWithItem:_rowAccessoryContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.rowAccessoryView attribute:NSLayoutAttributeLeft multiplier:1. constant:0];
        _accessoryContentViewcenterYConstraint = [NSLayoutConstraint constraintWithItem:_rowAccessoryContentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.rowAccessoryView attribute:NSLayoutAttributeCenterY multiplier:1. constant:0];
        _accessoryContentViewWidthConstraint = [NSLayoutConstraint constraintWithItem:_rowAccessoryContentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1. constant:_rowAccessoryContentView.frame.size.width];
        [self addConstraints:@[_accessoryContentViewLeftConstraint, _accessoryContentViewcenterYConstraint, _accessoryContentViewWidthConstraint]];
    }
    else
    {
        _rowAccessoryViewWidth = 0;
    }
    _rowAccessoryViewWidthConstraint.constant = _rowAccessoryViewWidth;
    
    [self setNeedsLayout];
}

-(void)setRowAccessoryType:(UITableViewCellAccessoryType)rowAccessoryType
{
    if(_rowAccessoryType == rowAccessoryType)
    {
        return;
    }
    _rowAccessoryType = rowAccessoryType;
    switch (rowAccessoryType) {
        case UITableViewCellAccessoryNone:
        {
            self.rowAccessoryView = nil;
        }
            break;
        case UITableViewCellAccessoryDisclosureIndicator:
        case UITableViewCellAccessoryDetailDisclosureButton:
        case UITableViewCellAccessoryDetailButton:
        {
            UIImage *indicatorImage = [XEFormSetting sharedSetting].cellSetting.indicatorImage;
            UIButton *indicatorView = [UIButton buttonWithType:UIButtonTypeCustom];
            [indicatorView setImage:indicatorImage forState:UIControlStateNormal];
            indicatorView.frame = CGRectMake(0, 0, indicatorImage.size.width, indicatorImage.size.height);
            indicatorView.tintColor = [XEFormSetting sharedSetting].cellSetting.indicatorViewTintColor;
            self.rowAccessoryView = indicatorView;
        }
            break;
        case UITableViewCellAccessoryCheckmark:
        {
            UIImage *checkMarkImage = [XEFormSetting sharedSetting].cellSetting.checkMarkImage;
            UIButton *checkMarkView = [UIButton buttonWithType:UIButtonTypeCustom];
            [checkMarkView setImage:checkMarkImage forState:UIControlStateNormal];
            checkMarkView.frame = CGRectMake(0, 0, checkMarkImage.size.width, checkMarkImage.size.height);
            checkMarkView.tintColor = self.tintColor;
            self.rowAccessoryView = checkMarkView;
        }
            break;
        default:
            break;
    }
    
}

@end
