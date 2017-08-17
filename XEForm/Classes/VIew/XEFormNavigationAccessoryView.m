//
//  XEFormNavigationAccessoryView.m
//  Pods
//
//  Created by 丁明 on 2017/8/16.
//
//

#import "XEFormNavigationAccessoryView.h"

@interface XEFormNavigationAccessoryView ()

@property (nonatomic, strong) UIBarButtonItem *fixedSpace;
@property (nonatomic, strong) UIBarButtonItem *flexibleSpace;

@end

@implementation XEFormNavigationAccessoryView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44.)];
    if (self)
    {
        self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth);
        NSArray * items = [NSArray arrayWithObjects:self.previousButton,
                           self.fixedSpace,
                           self.nextButton,
                           self.flexibleSpace,
                           self.doneButton, nil];
        [self setItems:items];
    }
    return self;
}


#pragma mark - Getter & setter

-(UIBarButtonItem *)previousButton
{
    if (nil == _previousButton)
    {
        _previousButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:105 target:nil action:nil];
    }
    return _previousButton;
}

-(UIBarButtonItem *)fixedSpace
{
    if (nil == _fixedSpace)
    {
        _fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        _fixedSpace.width = 22.0;
    }
    return _fixedSpace;
}

-(UIBarButtonItem *)nextButton
{
    if (nil == _nextButton)
    {
        _nextButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:106 target:nil action:nil];
    }
    return _nextButton;
}


-(UIBarButtonItem *)flexibleSpace
{
    if (nil == _flexibleSpace)
    {
        _flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    return _flexibleSpace;
}

-(UIBarButtonItem *)doneButton
{
    if (nil == _doneButton)
    {
        _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    }
    return _doneButton;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

@end
