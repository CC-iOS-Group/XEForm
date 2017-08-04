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
#import "UIImageView+XEForm.h"
#import "XEFormController.h"
#import "XEFormSetting.h"
#import "XEForm.h"
#import "XEFormCellAccessoryView.h"

@interface XEFormBaseCell ()
{
    CGFloat _rowAccessoryViewWidth;
    UIView *_rowAccessoryContentView;
    
    // AutoLayouts
    NSLayoutConstraint *_downSeparatorViewLeftConstraint;
    NSLayoutConstraint *_rowAccessoryViewWidthConstraint;
    
    NSLayoutConstraint *_accessoryContentViewLeftConstraint;
    NSLayoutConstraint *_accessoryContentViewcenterYConstraint;
    
    NSLayoutConstraint *_logoViewWidthConstraint;
    NSLayoutConstraint *_titleLabelLeftConstraint;
    
}

@property (nonatomic, assign) UITableViewCellStyle style;

@end

@implementation XEFormBaseCell

@synthesize row = _row;
@synthesize rowAccessoryView = _rowAccessoryView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
//        self.textLabel.font = [UIFont systemFontOfSize:XEFormDefaultFontSize];
//        XEFormLabelSetMinFontSize(self.textLabel, XEFormRowMinFontSize);
//        self.detailTextLabel.font = [UIFont systemFontOfSize:XEFormDefaultFontSize];
//        XEFormLabelSetMinFontSize(self.detailTextLabel, XEFormRowMinFontSize);
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
    [self addSubview:self.rowContentView];
    [self addSubview:self.rowAccessoryView];
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
    
    // rowAccessoryView
    topConstraint = [NSLayoutConstraint constraintWithItem:self.rowAccessoryView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    rightConstraint = [NSLayoutConstraint constraintWithItem:self.rowAccessoryView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-0];
    bottomConstraint = [NSLayoutConstraint constraintWithItem:self.rowAccessoryView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    _rowAccessoryViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.rowAccessoryView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_rowAccessoryViewWidth];
    [self addConstraints: @[topConstraint, rightConstraint, bottomConstraint, _rowAccessoryViewWidthConstraint]];
    
    // Row content view
    topConstraint = [NSLayoutConstraint constraintWithItem:self.rowContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    rightConstraint = [NSLayoutConstraint constraintWithItem:self.rowContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.rowAccessoryView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-0];
    bottomConstraint = [NSLayoutConstraint constraintWithItem:self.rowContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    leftConstraint = [NSLayoutConstraint constraintWithItem:self.rowContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self addConstraints:@[topConstraint, rightConstraint, bottomConstraint, leftConstraint]];
    
    // Row Logo View
    leftConstraint = [NSLayoutConstraint constraintWithItem:self.rowLogoView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.rowContentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:[XEFormSetting sharedSetting].cellSetting.offsetX];
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.rowLogoView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.rowContentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    heightConstraint = [NSLayoutConstraint constraintWithItem:self.rowLogoView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1. constant:[XEFormSetting sharedSetting].cellSetting.logoSize.height];
    _logoViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.rowLogoView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1. constant:[XEFormSetting sharedSetting].cellSetting.logoSize.width];
    [self addConstraints:@[leftConstraint, centerYConstraint, _logoViewWidthConstraint, heightConstraint]];
    
    // Title Label
    centerYConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.rowContentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.rowContentView attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0];
    _titleLabelLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.rowLogoView attribute:NSLayoutAttributeRight multiplier:1.0 constant:[XEFormSetting sharedSetting].cellSetting.offsetX];
    [self addConstraints:@[centerYConstraint, widthConstraint, _titleLabelLeftConstraint]];
    
    // Description Label
    centerYConstraint = [NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.rowContentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    rightConstraint = [NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.rowContentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-[XEFormSetting sharedSetting].cellSetting.offsetX];
    leftConstraint = [NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.titleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraints:@[centerYConstraint, rightConstraint, leftConstraint]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

- (void)update
{
    if(self.row.indexPath.row == 0)
    {
        // First cell in section
        self.upSeparatorView.hidden = NO;
    }
    else
    {
        self.upSeparatorView.hidden = YES;
    }
    
    if([self.row.form numberOfRowsInSection: self.row.indexPath.section] == self.row.indexPath.row + 1)
    {
        // Last cell in section
        _downSeparatorViewLeftConstraint.constant = 0;
    }
    else
    {
        _downSeparatorViewLeftConstraint.constant = [XEFormSetting sharedSetting].cellSetting.offsetX;
    }
    
    if (self.row.logoStr)
    {
        _logoViewWidthConstraint.constant = [XEFormSetting sharedSetting].cellSetting.logoSize.width;
        _titleLabelLeftConstraint.constant = [XEFormSetting sharedSetting].cellSetting.offsetX;
        NSURL *logoUrl = [NSURL URLWithString:self.row.logoStr];
        if (logoUrl)
        {
            if (logoUrl.host)
            {
                [self.rowLogoView setImageWithURL:logoUrl placeholder:[XEFormSetting sharedSetting].cellSetting.logoPlaceholder];
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
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Private method

- (NSIndexPath *)indexPathForNextCell
{
    UITableView *tableView = self.tableView;
    NSIndexPath *indexPath = [tableView indexPathForCell:self];
    if (indexPath)
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
    return nil;
}

- (UITableViewCell <XEFormRowCellDelegate> *)nextCell
{
    UITableView *tableView = [self tableView];
    NSIndexPath *indexPath = [self indexPathForNextCell];
    if (indexPath)
    {
        //get next cell
        return (UITableViewCell <XEFormRowCellDelegate> *)[tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - XEFormRowCellDelegate

+(CGFloat)heightForRow:(XEFormRowObject *)row width:(CGFloat)width
{
    return [XEFormSetting sharedSetting].cellSetting.cellHeight;
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
    //configure cell after setting row as well
    if(_row.cellConfig)
    {
        [_row.cellConfig enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL * _Nonnull stop) {
            [self setValue:obj forKeyPath:key];
        }];
    }
    
    [self update];
    [self setNeedsDisplay];
}

#pragma mark UI

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

-(UILabel *)titleLabel
{
    if (nil == _titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    return _titleLabel;
}

-(UILabel *)descriptionLabel
{
    if (nil == _descriptionLabel)
    {
        _descriptionLabel = [[UILabel alloc] init];
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
        [self.rowAccessoryView removeConstraints:@[_accessoryContentViewLeftConstraint, _accessoryContentViewcenterYConstraint]];
        [_rowAccessoryContentView removeFromSuperview];
    }
    _rowAccessoryContentView = rowAccessoryView;
    _rowAccessoryContentView.translatesAutoresizingMaskIntoConstraints = NO;
    _rowAccessoryContentView.tintColor = [XEFormSetting sharedSetting].cellSetting.rowAccessoryViewTintColor;
 
    if(_rowAccessoryContentView)
    {
        _rowAccessoryViewWidth = _rowAccessoryContentView.frame.size.width + [XEFormSetting sharedSetting].cellSetting.offsetX;
        [self.rowAccessoryView addSubview:_rowAccessoryContentView];
        _accessoryContentViewLeftConstraint = [NSLayoutConstraint constraintWithItem:_rowAccessoryContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.rowAccessoryView attribute:NSLayoutAttributeLeft multiplier:1. constant:0];
        _accessoryContentViewcenterYConstraint = [NSLayoutConstraint constraintWithItem:_rowAccessoryContentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.rowAccessoryView attribute:NSLayoutAttributeCenterY multiplier:1. constant:0];
        [self.rowAccessoryView addConstraints:@[_accessoryContentViewLeftConstraint, _accessoryContentViewcenterYConstraint]];
    }
    else
    {
        
    }
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
            self.rowAccessoryView = indicatorView;
        }
            break;
        case UITableViewCellAccessoryCheckmark:
        {
            UIImage *checkMarkImage = [XEFormSetting sharedSetting].cellSetting.checkMarkImage;
            UIButton *checkMarkView = [UIButton buttonWithType:UIButtonTypeCustom];
            [checkMarkView setImage:checkMarkImage forState:UIControlStateNormal];
            checkMarkView.frame = CGRectMake(0, 0, checkMarkImage.size.width, checkMarkImage.size.height);
            self.rowAccessoryView = checkMarkView;
        }
            break;
        default:
            break;
    }
    _rowAccessoryViewWidthConstraint.constant = _rowAccessoryViewWidth;
    
    [self setNeedsLayout];
}

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
