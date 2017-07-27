//
//  XEFormController.m
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import "XEFormController.h"

#import "XEFormSectionObject.h"
#import "XEFormConst.h"
#import "XEFormRowObject.h"
#import "XETemplateForm.h"
#import "XEFormUtils.h"

#import "XEFormRowCellDelegate.h"
#import "XEFormViewController.h"

@interface XEFormController ()

@end

@implementation XEFormController

#pragma mark - Class register

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _cellHeightCache = [NSMutableDictionary dictionary];
        _cellClassesForRowTypes = [@{
                                       XEFormRowTypeDefault: NSClassFromString(@"XEFormDefaultCell"),
                                       XEFormRowTypeText: NSClassFromString(@"XEFormTextFieldCell"),
                                       XEFormRowTypeLongText: NSClassFromString(@"XEFormTextViewCell"),
                                       XEFormRowTypeURL: NSClassFromString(@"XEFormTextFieldCell"),
                                       XEFormRowTypeEmail: NSClassFromString(@"XEFormTextFieldCell"),
                                       XEFormRowTypePhone: NSClassFromString(@"XEFormTextFieldCell"),
                                       XEFormRowTypePassword: NSClassFromString(@"XEFormTextFieldCell"),
                                       XEFormRowTypeNumber: NSClassFromString(@"XEFormTextFieldCell"),
                                       XEFormRowTypeFloat: NSClassFromString(@"XEFormTextFieldCell"),
                                       XEFormRowTypeInteger: NSClassFromString(@"XEFormTextFieldCell"),
                                       XEFormRowTypeUnsigned: NSClassFromString(@"XEFormTextFieldCell"),
                                       XEFormRowTypeBoolean: NSClassFromString(@"XEFormSwitchCell"),
                                       XEFormRowTypeDate: NSClassFromString(@"XEFormDatePickerCell"),
                                       XEFormRowTypeTime: NSClassFromString(@"XEFormDatePickerCell"),
                                       XEFormRowTypeDateTime: NSClassFromString(@"XEFormDatePickerCell"),
                                       XEFormRowTypeImage: NSClassFromString(@"XEFormImagePickerCell"),
                                       

                                       } mutableCopy];
        _cellClassesForRowClasses = [@{
                                         
                                         } mutableCopy];
        _controllerClassesForRowTypes = [@{
                                             XEFormRowTypeDefault: [XEFormViewController class],
                                             } mutableCopy];
        _controllerClassesForRowClasses = [NSMutableDictionary dictionary];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardDidShow:)
//                                                     name:UIKeyboardDidShowNotification
//                                                   object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWillHide:)
//                                                     name:UIKeyboardWillHideNotification
//                                                   object:nil];
    }
    return self;
}

-(void)dealloc
{
    _formTableView.delegate = nil;
    _formTableView.dataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(Class)cellClassForRow:(XEFormRowObject *)row
{
    if (row.type != XEFormRowTypeDefault)
    {
        return self.cellClassesForRowTypes[row.type] ? :
        self.parentFormController.cellClassesForRowTypes[row.type] ? :
        self.cellClassesForRowTypes[XEFormRowTypeDefault];
    }
    else
    {
        Class valueClass = row.valueClass;
        while (valueClass && valueClass != [NSObject class]) {
            Class cellClass = self.cellClassesForRowClasses[NSStringFromClass(valueClass)] ? :
            self.parentFormController.cellClassesForRowClasses[NSStringFromClass(valueClass)];
            if (cellClass)
            {
                return cellClass;
            }
            valueClass = [valueClass superclass];
        }
        return self.cellClassesForRowTypes[XEFormRowTypeDefault];
    }
}

- (void)registerDefaultRowCellClass:(Class)cellClass
{
    NSParameterAssert([cellClass conformsToProtocol:@protocol(XEFormRowCellDelegate)]);
    if(cellClass) [self.cellClassesForRowTypes setDictionary:@{XEFormRowTypeDefault: cellClass}];
}

- (void)registerCellClass:(Class)cellClass forRowType:(NSString *)rowType
{
    NSParameterAssert([cellClass conformsToProtocol:@protocol(XEFormRowCellDelegate)]);
    if(rowType) self.cellClassesForRowTypes[rowType] = cellClass;
}

- (void)registerCellClass:(Class)cellClass forRowClass:(__unsafe_unretained Class)rowClass
{
    NSParameterAssert([cellClass conformsToProtocol:@protocol(XEFormRowCellDelegate)]);
    if(rowClass) self.cellClassesForRowClasses[NSStringFromClass(rowClass)] = cellClass;
}

-(Class)viewControllerClassForRow:(XEFormRowObject *)row
{
    if(row.type != XEFormRowTypeDefault)
    {
        return self.controllerClassesForRowTypes[row.type] ?:
        self.parentFormController.controllerClassesForRowTypes[row.type] ?:
        self.controllerClassesForRowTypes[XEFormRowTypeDefault];
    }
    else
    {
        Class valueClass = row.valueClass;
        while (valueClass != [NSObject class])
        {
            Class controllerClass = self.controllerClassesForRowClasses[NSStringFromClass(valueClass)] ?:
            self.parentFormController.controllerClassesForRowClasses[NSStringFromClass(valueClass)];
            if (controllerClass)
            {
                return controllerClass;
            }
            valueClass = [valueClass superclass];
        }
        return self.controllerClassesForRowTypes[XEFormRowTypeDefault];
    }
}

- (void)registerDefaultViewControllerClass:(Class)controllerClass
{
    NSParameterAssert([controllerClass conformsToProtocol:@protocol(XEFormRowViewControllerDelegate)]);
    if(controllerClass) [self.controllerClassesForRowTypes setDictionary:@{XEFormRowTypeDefault: controllerClass}];
}

- (void)registerViewControllerClass:(Class)controllerClass forRowType:(NSString *)rowType
{
    NSParameterAssert([controllerClass conformsToProtocol:@protocol(XEFormRowViewControllerDelegate)]);
    if(rowType) self.controllerClassesForRowTypes[rowType] = controllerClass;
}

- (void)registerViewControllerClass:(Class)controllerClass forRowClass:(__unsafe_unretained Class)rowClass
{
    NSParameterAssert([controllerClass conformsToProtocol:@protocol(XEFormRowViewControllerDelegate)]);
    if(rowClass) self.controllerClassesForRowClasses[NSStringFromClass(rowClass)] = controllerClass;
}

#pragma mark - forward Method



- (BOOL)respondsToSelector:(SEL)selector
{
    return [super respondsToSelector:selector] || [self.delegate respondsToSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:self.delegate];
}

#pragma mark - Data

- (NSUInteger)numberOfSections
{
    return [self.form.sections count];
}

- (XEFormSectionObject *)sectionAtIndex:(NSUInteger)index
{
    return self.form.sections[index];
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)index
{
    return [self sectionAtIndex:index].rows.count;
}

- (XEFormRowObject *)rowForIndexPath:(NSIndexPath *)indexPath
{
    return [self sectionAtIndex:indexPath.section].rows[indexPath.row];
}

- (NSIndexPath *)indexPathForRow:(XEFormRowObject *)row
{
    NSUInteger sectionIndex = 0;
    for (XEFormSectionObject *section in self.form.sections)
    {
        NSUInteger fieldIndex = [section.rows indexOfObject:row];
        if (fieldIndex != NSNotFound)
        {
            return [NSIndexPath indexPathForRow:fieldIndex inSection:sectionIndex];
        }
        sectionIndex ++;
    }
    return nil;
}

- (void)enumerateRowsWithBlock:(void (^)(XEFormRowObject *row, NSIndexPath *indexPath))block
{
    NSUInteger sectionIndex = 0;
    for (XEFormSectionObject *section in self.form.sections)
    {
        NSUInteger fieldIndex = 0;
        for (XEFormRowObject *row in section.rows)
        {
            block(row, [NSIndexPath indexPathForRow:fieldIndex inSection:sectionIndex]);
            fieldIndex ++;
        }
        sectionIndex ++;
    }
}

#pragma mark - Action Handle

- (void)performAction:(SEL)selector withSender:(id)sender
{
    //walk up responder chain
    id responder = self.formTableView;
    while (responder)
    {
        if ([responder respondsToSelector:selector])
        {
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            [responder performSelector:selector withObject:sender];
            
#pragma clang diagnostic pop
            
            return;
        }
        responder = [responder nextResponder];
    }
    
    //trye parent controller
    if (self.parentFormController)
    {
        [self.parentFormController performAction:selector withSender:sender];
    }
    else
    {
        [NSException raise:XEFormsException format:@"No object in the responder chain responds to the selector %@", NSStringFromSelector(selector)];
    }
}

#pragma mark - Notification Handle

//- (UITableViewCell *)cellContainingView:(UIView *)view
//{
//    if (view == nil || [view isKindOfClass:[UITableViewCell class]])
//    {
//        return (UITableViewCell *)view;
//    }
//    return [self cellContainingView:view.superview];
//}
//// TODO: there is a bug when show keyboard
//- (void)keyboardDidShow:(NSNotification *)notification
//{
//    UITableViewCell *cell = [self cellContainingView:XEFormsFirstResponder(self.formTableView)];
//    if (cell && ![self.delegate isKindOfClass:[UITableViewController class]])
//    {
//        // calculate the size of the keyboard and how much is and isn't covering the tableview
//        NSDictionary *keyboardInfo = [notification userInfo];
//        CGRect keyboardFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        keyboardFrame = [self.formTableView.window convertRect:keyboardFrame toView:self.formTableView.superview];
//        CGFloat heightOfTableViewThatIsCoveredByKeyboard = self.formTableView.frame.origin.y + self.formTableView.frame.size.height - keyboardFrame.origin.y;
//        CGFloat heightOfTableViewThatIsNotCoveredByKeyboard = self.formTableView.frame.size.height - heightOfTableViewThatIsCoveredByKeyboard;
//        
//        UIEdgeInsets tableContentInset = self.formTableView.contentInset;
//        self.originalTableContentInset = tableContentInset;
//        tableContentInset.bottom = heightOfTableViewThatIsCoveredByKeyboard;
//        
//        UIEdgeInsets tableScrollIndicatorInsets = self.formTableView.scrollIndicatorInsets;
//        tableScrollIndicatorInsets.bottom += heightOfTableViewThatIsCoveredByKeyboard;
//        
//        [UIView beginAnimations:nil context:nil];
//        
//        // adjust the tableview insets by however much the keyboard is overlapping the tableview
//        self.formTableView.contentInset = tableContentInset;
//        self.formTableView.scrollIndicatorInsets = tableScrollIndicatorInsets;
//        
//        UIView *firstResponder = XEFormsFirstResponder(self.formTableView);
//        if ([firstResponder isKindOfClass:[UITextView class]])
//        {
//            UITextView *textView = (UITextView *)firstResponder;
//            
//            // calculate the position of the cursor in the textView
//            NSRange range = textView.selectedRange;
//            UITextPosition *beginning = textView.beginningOfDocument;
//            UITextPosition *start = [textView positionFromPosition:beginning offset:range.location];
//            UITextPosition *end = [textView positionFromPosition:start offset:range.length];
//            CGRect caretFrame = [textView caretRectForPosition:end];
//            
//            // convert the cursor to the same coordinate system as the tableview
//            CGRect caretViewFrame = [textView convertRect:caretFrame toView:self.formTableView.superview];
//            
//            // padding makes sure that the cursor isn't sitting just above the
//            // keyboard and will adjust to 3 lines of text worth above keyboard
//            CGFloat padding = textView.font.lineHeight * 3;
//            CGFloat keyboardToCursorDifference = (caretViewFrame.origin.y + caretViewFrame.size.height) - heightOfTableViewThatIsNotCoveredByKeyboard + padding;
//            
//            // if there is a difference then we want to adjust the keyboard, otherwise
//            // the cursor is fine to stay where it is and the keyboard doesn't need to move
//            if (keyboardToCursorDifference > 0)
//            {
//                // adjust offset by this difference
//                CGPoint contentOffset = self.formTableView.contentOffset;
//                contentOffset.y += keyboardToCursorDifference;
//                [self.formTableView setContentOffset:contentOffset animated:YES];
//            }
//        }
//        
//        [UIView commitAnimations];
//    }
//}
//
//- (void)keyboardWillHide:(NSNotification *)note
//{
//    UITableViewCell *cell = [self cellContainingView:XEFormsFirstResponder(self.formTableView)];
//    if (cell && ![self.delegate isKindOfClass:[UITableViewController class]])
//    {
//        NSDictionary *keyboardInfo = [note userInfo];
//        UIEdgeInsets tableScrollIndicatorInsets = self.formTableView.scrollIndicatorInsets;
//        tableScrollIndicatorInsets.bottom = 0;
//        
//        //restore insets
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationCurve:(UIViewAnimationCurve)keyboardInfo[UIKeyboardAnimationCurveUserInfoKey]];
//        [UIView setAnimationDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
//        self.formTableView.contentInset = self.originalTableContentInset;
//        self.formTableView.scrollIndicatorInsets = tableScrollIndicatorInsets;
//        self.originalTableContentInset = UIEdgeInsetsZero;
//        [UIView commitAnimations];
//    }
//}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self numberOfSections];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self sectionAtIndex:section].header description];
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [[self sectionAtIndex:section].footer description];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfRowsInSection:section];
}

- (UITableViewCell *)cellForRow:(XEFormRowObject *)row
{
    //don't recycle cells - it would make things complicated
    Class cellClass = row.cellClass ? : [self cellClassForRow:row];
    NSString *nibName = NSStringFromClass(cellClass);
    if ([nibName rangeOfString:@"."].location != NSNotFound) {
        nibName = nibName.pathExtension; //Removes Swift namespace
    }
    if ([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"])
    {
        //load cell from nib
        return [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] firstObject];
    }
    else
    {

        UITableViewCellStyle style = UITableViewCellStyleDefault;
        id styleNum = [row.cellConfig objectForKey:@"style"];
        if (styleNum)
        {
            style = [styleNum integerValue];
        }
        else if (row.needDescription)
        {
            style = UITableViewCellStyleValue1;
        }

        //don't recycle cells - it would make things complicated
        return [[cellClass alloc] initWithStyle:style reuseIdentifier:NSStringFromClass(cellClass)];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XEFormRowObject *row = [self rowForIndexPath:indexPath];
    Class cellClass = row.cellClass ? : [self cellClassForRow:row];
    if([cellClass respondsToSelector:@selector(heightForRow:width:)])
    {
        return [cellClass heightForRow:row width:self.formTableView.frame.size.width];
    }
    
    NSString *className = NSStringFromClass(cellClass);
    NSNumber *cachedHeight = _cellHeightCache[className];
    if(!cachedHeight)
    {
        UITableViewCell *cell = [self cellForRow:row];
        cachedHeight = @(cell.bounds.size.height);
        _cellHeightCache[className] = cachedHeight;
    }
    
    return [cachedHeight floatValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellForRow:[self rowForIndexPath:indexPath]];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView beginUpdates];
        
        [self.form removeRowAtIndexPath:indexPath];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.form moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    XEFormSectionObject *section = [self sectionAtIndex:sourceIndexPath.section];
    if (sourceIndexPath.section == proposedDestinationIndexPath.section &&
        proposedDestinationIndexPath.row < (NSInteger)[section.rows count] - 1)
    {
        return proposedDestinationIndexPath;
    }
    return sourceIndexPath;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    XEFormSectionObject *section = [self sectionAtIndex:indexPath.section];
    if ([self.form isKindOfClass:[XETemplateForm class]])
    {
        if (indexPath.row < section.rows.count -1)
        {
            XEFormRowObject *row = self.form.row;
            return row ? ([row isOrderedCollectionType] && row.isSortable) : NO;
        }
    }
    return NO;
}

#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //forward to delegate
    if ([self.delegate respondsToSelector:_cmd])
    {
        return [self.delegate tableView:tableView viewForHeaderInSection:section];
    }
    
    //handle view or class
    id header = [self sectionAtIndex:section].header;
    if ([header isKindOfClass:[UIView class]])
    {
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //forward to delegate
    if ([self.delegate respondsToSelector:_cmd])
    {
        return [self.delegate tableView:tableView heightForHeaderInSection:section];
    }
    
    //handle view or class
    UIView *header = [self sectionAtIndex:section].header;
    if ([header isKindOfClass:[UIView class]])
    {
        return header.frame.size.height ?: UITableViewAutomaticDimension;
    }
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //forward to delegate
    if ([self.delegate respondsToSelector:_cmd])
    {
        return [self.delegate tableView:tableView viewForFooterInSection:section];
    }
    
    //handle view or class
    id footer = [self sectionAtIndex:section].footer;
    if ([footer isKindOfClass:[UIView class]])
    {
        return footer;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //forward to delegate
    if ([self.delegate respondsToSelector:_cmd])
    {
        return [self.delegate tableView:tableView heightForFooterInSection:section];
    }
    
    //handle view or class
    UIView *footer = [self sectionAtIndex:section].footer;
    if ([footer isKindOfClass:[UIView class]])
    {
        return footer.frame.size.height ?: UITableViewAutomaticDimension;
    }
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    XEFormRowObject *row = [self rowForIndexPath:indexPath];
    
    // set form row
     ((id<XEFormRowCellDelegate>)cell).row = row;
        
    //forward to delegate
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //forward to cell
    UITableViewCell<XEFormRowCellDelegate> *cell = (UITableViewCell<XEFormRowCellDelegate> *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(didSelectWithTableView:controller:)])
    {
        [cell didSelectWithTableView:tableView controller:[self tableViewController]];
    }
    
    //forward to delegate
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(__unused UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XEFormSectionObject *section = [self sectionAtIndex:indexPath.section];
    if ([self.form isKindOfClass:[XETemplateForm class]])
    {
        if (indexPath.row == (NSInteger)[section.rows count] - 1)
        {
            return UITableViewCellEditingStyleInsert;
        }
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(__unused UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(__unused NSIndexPath *)indexPath
{
    return NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //dismiss keyboard
    [XEFormsFirstResponder(self.formTableView) resignFirstResponder];
    
    //forward to delegate
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate scrollViewWillBeginDragging:scrollView];
    }
}

#pragma mark - Getter & setter

-(void)setDelegate:(id<XEFormControllerDelegate>)delegate
{
    _delegate = delegate;
    
    //force table to update respondsToSelector: cache
    self.formTableView.delegate = nil;
    self.formTableView.dataSource = self;
}

-(void)setFormTableView:(UITableView *)formTableView
{
    _formTableView = formTableView;
    self.formTableView.dataSource = self;
    self.formTableView.delegate = self;
    self.formTableView.editing = YES;
    self.formTableView.allowsSelectionDuringEditing = YES;
    if([_delegate respondsToSelector:@selector(didSetFormTableView:)])
    {
        [_delegate didSetFormTableView:_formTableView];
    }
    [self.formTableView reloadData];
}

-(UIViewController *)tableViewController
{
    id responder = self.formTableView;
    while (responder)
    {
        if ([responder isKindOfClass:[UIViewController class]])
        {
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

-(void)setForm:(XEForm *)form
{
    _form = form;
    _form.formController = self;
}



@end
