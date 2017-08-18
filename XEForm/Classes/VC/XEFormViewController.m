//
//  XEFormViewController.m
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import "XEFormViewController.h"

#import "XEFormController.h"
#import "XEFormObject.h"
#import "XEFormRowObject.h"
#import "XEOptionsForm.h"
#import "XETemplateForm.h"
#import "XEFormUtils.h"
#import "UIView+XEForm.h"

#import <objc/runtime.h>

#import "XEFormTextFieldCell.h"

@interface XEFormViewController ()
{
    NSNumber *_oldBottomTableContentInset;
    CGRect _keyboardFrame;
}

@property (nonatomic, strong, readwrite) XEFormController *formController;

@end

@implementation XEFormViewController

@synthesize row = _row;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (nil == self.tableView.superview)
    {
        [self.view addSubview: self.tableView];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    
    if(selected)
    {
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:selected animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self.tableView deselectRowAtIndexPath:selected animated:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.frame;
}

-(void)dealloc
{
    NSLog(@"%@ has dealloc", NSStringFromClass([self class]));
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)tableView
{
    return self.formController.formTableView;
}


#pragma mark - Notification handle

- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    UIView *firstResponderView = [self.tableView findFirstResponder];
    XEFormBaseCell *cell = [firstResponderView formCell];
    if (cell)
    {
        NSDictionary *keyboardInfo = [notification userInfo];
        _keyboardFrame = [self.tableView.window convertRect:[keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] toView:self.tableView.superview];
        CGFloat newBottomInset = self.tableView.frame.origin.y + self.tableView.frame.size.height - _keyboardFrame.origin.y;
        UIEdgeInsets tableContentInset = self.tableView.contentInset;
        UIEdgeInsets tableScrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
        _oldBottomTableContentInset = _oldBottomTableContentInset ? : @(tableContentInset.bottom);
        if (newBottomInset > _oldBottomTableContentInset.floatValue)
        {
            tableContentInset.bottom = newBottomInset;
            tableScrollIndicatorInsets.bottom = tableContentInset.bottom;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
            [UIView setAnimationCurve:[keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
            self.tableView.contentInset = tableContentInset;
            self.tableView.scrollIndicatorInsets = tableScrollIndicatorInsets;
            NSIndexPath *selectedRow = [self.tableView indexPathForCell:cell];
            [self.tableView scrollToRowAtIndexPath:selectedRow atScrollPosition:UITableViewScrollPositionNone animated:NO];
            [UIView commitAnimations];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIView *firstResponderView = XEFormsFirstResponder(self.tableView);
    XEFormBaseCell *cell = [firstResponderView formCell];
    if (cell)
    {
        _keyboardFrame = CGRectZero;
        NSDictionary *keyboardInfo = [notification userInfo];
        UIEdgeInsets tableContentInset = self.tableView.contentInset;
        UIEdgeInsets tableScrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
        tableContentInset.bottom = _oldBottomTableContentInset.floatValue;
        tableScrollIndicatorInsets.bottom = tableContentInset.bottom;
        _oldBottomTableContentInset = nil;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        [UIView setAnimationCurve:[keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
        self.tableView.contentInset = tableContentInset;
        self.tableView.scrollIndicatorInsets = tableScrollIndicatorInsets;
        [UIView commitAnimations];
    }
}



#pragma mark - Navigation Between Fields


-(void)rowNavigationNextAction
{
 
    [self navigateToDirection: XEFormNavigationDirectionNext];
    
}

-(void)rowNavigationPreviousAction
{
    
    [self navigateToDirection: XEFormNavigationDirectionPrevious];
    
}

-(void)rowNavigationDone:(UIBarButtonItem *)sender
{
    // cell which is first responder
    UIView *firstResponderView = [self.tableView findFirstResponder];
    XEFormBaseCell *cell = [firstResponderView formCell];
    [cell updateRowValueFromOther];
    
    [self.tableView endEditing:YES];
}


-(void)navigateToDirection:(XEFormNavigationDirection)direction
{
    UIView *firstResponderView = [self.tableView findFirstResponder];
    XEFormBaseCell *cell = [firstResponderView formCell];
    XEFormBaseCell *nextCell = [cell nextCellWithDirection:direction];
    if (nextCell)
    {
        if ([nextCell canBecomeFirstResponder])
        {
            NSIndexPath * nextIndexPath = [self.tableView indexPathForCell:nextCell];
            [self.tableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            [nextCell becomeFirstResponder];
        }
    }
    
}

#pragma mark  - XEFormControllerDelegate


#pragma mark - Private




#pragma mark - Getter & setter

-(void)setRow:(XEFormRowObject *)row
{
    _row = row;
    
    XEFormObject *form = nil;
    if (row.options)
    {
        form = [[XEOptionsForm alloc] initWithRow:row];
    }
    else if ([row isCollectionType])
    {
        form = [[XETemplateForm alloc] initWithRow:row];
    }
    else if([row.valueClass isSubclassOfClass:[XEFormObject class]])
    {
        if (!row.value && ![row.valueClass isSubclassOfClass:XEFormClassFromString(@"NSManagedObject")])
        {
            row.value = [[row.valueClass alloc] init];
        }
        form = row.value;
    }
    else
    {
        [NSException raise:XEFormsException format:@"XEFormViewController row value must be subclass of XEForm"];
    }
    
    self.formController.parentFormController = row.form.formController;
    self.formController.form = form;
}

-(XEFormController *)formController
{
    if (nil == _formController)
    {
        _formController = [[XEFormController alloc] init];
        _formController.formViewController = self;
    }
    return _formController;
}

-(XEFormNavigationAccessoryView *)navigationAccessoryView
{
    if (nil == _navigationAccessoryView)
    {
        _navigationAccessoryView = [XEFormNavigationAccessoryView new];
        _navigationAccessoryView.previousButton.target = self;
        _navigationAccessoryView.previousButton.action = @selector(rowNavigationPreviousAction);
        _navigationAccessoryView.nextButton.target = self;
        _navigationAccessoryView.nextButton.action = @selector(rowNavigationNextAction);
        _navigationAccessoryView.doneButton.target = self;
        _navigationAccessoryView.doneButton.action = @selector(rowNavigationDone:);
        _navigationAccessoryView.tintColor = self.view.tintColor;
    }
    return _navigationAccessoryView;
}


@end
