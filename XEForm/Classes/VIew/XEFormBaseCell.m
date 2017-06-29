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

static const CGFloat kDefaultFontSize = 17.;

@implementation XEFormBaseCell

@synthesize row = _row;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.font = [UIFont boldSystemFontOfSize:kDefaultFontSize];
        XEFormLabelSetMinFontSize(self.textLabel, XEFormRowMinFontSize);
        self.detailTextLabel.font = [UIFont systemFontOfSize:kDefaultFontSize];
        XEFormLabelSetMinFontSize(self.detailTextLabel, XEFormRowMinFontSize);
        
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
    //override
}

- (void)update
{
    //override
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

#pragma mark - Getter & setter

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    //don't distinguish between these, because we're always in edit mode
    super.accessoryType = accessoryType;
    super.editingAccessoryType = accessoryType;
}

- (void)setEditingAccessoryType:(UITableViewCellAccessoryType)editingAccessoryType
{
    //don't distinguish between these, because we're always in edit mode
    [self setAccessoryType:editingAccessoryType];
}

- (void)setAccessoryView:(UIView *)accessoryView
{
    //don't distinguish between these, because we're always in edit mode
    super.accessoryView = accessoryView;
    super.editingAccessoryView = accessoryView;
}

- (void)setEditingAccessoryView:(UIView *)editingAccessoryView
{
    //don't distinguish between these, because we're always in edit mode
    [self setAccessoryView:editingAccessoryView];
}

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
    //configure cell after setting field as well
    if(_row.cellConfig)
    {
        [_row.cellConfig removeObjectForKey:@"style"];
        [_row.cellConfig enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL * _Nonnull stop) {
            [self setValue:obj forKeyPath:key];
        }];
    }
    
//    if([self respondsToSelector:@selector(configWithValue:)])
//    {
//        [self configWithValue:row.value];
//    }
    
    [self update];
    [self setNeedsDisplay];
}

@end
