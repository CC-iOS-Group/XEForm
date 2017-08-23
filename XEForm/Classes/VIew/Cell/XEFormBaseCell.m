//
//  XEFormBaseCell.m
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import "XEFormBaseCell.h"
#import "XEFormRowObject.h"

#import "XEFormUtils.h"
#import "XEFormConst.h"
#import "XEFormController.h"
#import "XEFormSetting.h"
#import "XEFormObject.h"
#import "XEFormCellAccessoryView.h"
#import "XEFormViewController.h"

@interface XEFormBaseCell ()
{
    NSLayoutConstraint *_downSeparatorViewLeftConstraint;
}

@end

@implementation XEFormBaseCell

@synthesize row = _row;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // TODO: support
        self.style = style;
        super.accessoryType = UITableViewCellAccessoryNone;
        if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        {
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else
        {
            self.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    [self addSubview:self.upSeparatorView];
    [self addSubview:self.downSeparatorView];
    
    // upSeparatorView
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.upSeparatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.upSeparatorView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.upSeparatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-0];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.upSeparatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[XEFormSetting sharedSetting].cellSetting.separatorHeight];
    [self addConstraints: @[topConstraint, leftConstraint, rightConstraint, heightConstraint]];
    
    // downSeparatorView
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.downSeparatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    _downSeparatorViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.downSeparatorView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    rightConstraint = [NSLayoutConstraint constraintWithItem:self.downSeparatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-0];
    heightConstraint = [NSLayoutConstraint constraintWithItem:self.downSeparatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[XEFormSetting sharedSetting].cellSetting.separatorHeight];
    [self addConstraints: @[bottomConstraint, _downSeparatorViewLeftConstraint, rightConstraint, heightConstraint]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

- (void)update
{
    NSIndexPath *indexPath = [self.row.form indexPathForRow:self.row];
    if (indexPath)
    {
        if(indexPath.row == 0)
        {
            // First cell in section
            self.upSeparatorView.hidden = NO;
        }
        else
        {
            self.upSeparatorView.hidden = YES;
        }
        
        if([self.row.form numberOfRowsInSection: indexPath.section] == indexPath.row + 1)
        {
            // Last cell in section
            _downSeparatorViewLeftConstraint.constant = 0;
        }
        else
        {
            _downSeparatorViewLeftConstraint.constant = [XEFormSetting sharedSetting].cellSetting.offsetX;
        }
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)updateRowValueFromOther
{
    
    
}

-(UIView *)inputAccessoryView
{
    if(![self canBecomeFirstResponder])
    {
        return nil;
    }
    else
    {
        XEFormBaseCell *nextCell = [self nextCellWithDirection:XEFormNavigationDirectionNext];
        XEFormBaseCell *previousCell = [self nextCellWithDirection:XEFormNavigationDirectionPrevious];
        
        if([self.delegate isKindOfClass:[XEFormViewController class]])
        {
            XEFormViewController *formVC = (XEFormViewController *)self.delegate;
            [formVC.navigationAccessoryView.previousButton setEnabled:(previousCell != nil)];
            [formVC.navigationAccessoryView.nextButton setEnabled:(nextCell != nil)];
            return formVC.navigationAccessoryView;
        }
        return nil;
        
    }
}

#pragma mark - Private method

- (NSIndexPath *)indexPathForNextCellWithDirection:(XEFormNavigationDirection)direction
{
    UITableView *tableView = self.tableView;
    NSIndexPath *indexPath = [tableView indexPathForCell:self];
    if (indexPath)
    {
        switch (direction) {
            case XEFormNavigationDirectionNext:
            {
                //get next indexpath
                if ([tableView numberOfRowsInSection:indexPath.section] > indexPath.row + 1)
                {
                    return [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
                }
                else if ([tableView numberOfSections] > indexPath.section + 1)
                {
                    return [NSIndexPath indexPathForRow:0 inSection:indexPath.section + 1];
                }
            }
                break;
            case XEFormNavigationDirectionPrevious:
            {
                if (0 <= indexPath.row - 1)
                {
                    return [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
                }
                else if (0 <= indexPath.section - 1)
                {
                    return [NSIndexPath indexPathForRow:0 inSection:indexPath.section - 1];
                }
            }
                break;
            default:
                return nil;
                break;
        }
        
    }
    return nil;
}

- (XEFormBaseCell *)nextCellWithDirection:(XEFormNavigationDirection)direction
{
    UITableView *tableView = [self tableView];
    NSIndexPath *indexPath = [self indexPathForNextCellWithDirection:direction];
    if (indexPath)
    {
        //get next cell
        XEFormBaseCell *nextCell = [tableView cellForRowAtIndexPath:indexPath];
        if(![nextCell canBecomeFirstResponder])
        {
            return [nextCell nextCellWithDirection:direction];
        }
        else
        {
            return nextCell;
        }
    }
    return nil;
}

+(CGFloat)heightForRow:(XEFormRowObject *)row width:(CGFloat)width
{
    return row.cellSetting.cellHeight;
}

-(void)didSelectWithTableView:(UITableView *)tableView controller:(UIViewController *)controller
{
    // overwrite
    
    
}

#pragma mark - Getter & setter


- (UITableView *)tableView
{
    UITableView *view = (UITableView *)[self superview];
    while (![view isKindOfClass:[UITableView class]])
    {
        view = (UITableView *)[view superview];
    }
    return view;
}

-(void)setValue:(id)value forKeyPath:(NSString *)keyPath
{
    
    
    [super setValue:value forKeyPath:keyPath];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRow:(XEFormRowObject *)row
{
    _row = row;
    
    [self update];
    [self setNeedsDisplay];
}

#pragma mark UI

-(UIView *)upSeparatorView
{
    if (nil == _upSeparatorView)
    {
        _upSeparatorView = [[UIView alloc] init];
        _upSeparatorView.translatesAutoresizingMaskIntoConstraints = NO;
        _upSeparatorView.backgroundColor = [XEFormSetting sharedSetting].cellSetting.separatorColor;
        
    }
    
    return _upSeparatorView;
}

-(UIView *)downSeparatorView
{
    if (nil == _downSeparatorView)
    {
        _downSeparatorView = [[UIView alloc] init];
        _downSeparatorView.translatesAutoresizingMaskIntoConstraints = NO;
        _downSeparatorView.backgroundColor = [XEFormSetting sharedSetting].cellSetting.separatorColor;
        
    }
    return _downSeparatorView;
}

@end
