//
//  XEFormSegmentsCell.m
//  Pods
//
//  Created by 丁明 on 2017/7/6.
//
//

#import "XEFormSegmentsCell.h"

#import "XEFormConst.h"
#import "XEFormRowObject.h"

@interface XEFormSegmentsCell ()



@end

@implementation XEFormSegmentsCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect segmentedControlFrame = self.segmentedControl.frame;
    segmentedControlFrame.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + XEFormRowPaddingLeft;
    segmentedControlFrame.origin.y = (self.contentView.frame.size.height - segmentedControlFrame.size.height)/2;
    segmentedControlFrame.size.width = self.contentView.bounds.size.width - segmentedControlFrame.origin.x - XEFormRowPaddingRight;
    self.segmentedControl.frame = segmentedControlFrame;
    
}

#pragma mark - Customize

-(void)setUp
{
    [self.contentView addSubview:self.segmentedControl];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)update
{
    self.textLabel.text = self.row.title;
    self.textLabel.accessibilityValue = self.textLabel.text;
    
    [self.segmentedControl removeAllSegments];
    for (NSUInteger i = 0; i < [self.row optionCount]; i++) {
        [self.segmentedControl insertSegmentWithTitle:[self.row optionDescriptionAtIndex:i] atIndex:i animated:NO];
        if ([self.row isOptionSelectedAtIndex:i])
        {
            [self.segmentedControl setSelectedSegmentIndex:i];
        }
    }
}

#pragma mark - Action handle

- (void)valueChanged
{
    NSInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
    for (NSInteger i = 0; i < (NSInteger)[self.row rowDescription]; i++)
    {
        [self.row setOptionSelected:(selectedIndex == i) atIndex:i];
    }
    if (self.row.action)
    {
        self.row.action(self);
    }
}

#pragma mark  - Getter & setter

-(UISegmentedControl *)segmentedControl
{
    if (nil == _segmentedControl)
    {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[]];
        [_segmentedControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

@end
