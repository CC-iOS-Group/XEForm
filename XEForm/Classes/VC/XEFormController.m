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

#import "XEFormBaseCell.h"
#import "XEFormViewController.h"
#import "XEFormHeaderFooterView.h"
#import "XEFormSetting.h"

@interface XEFormController ()



@end

@implementation XEFormController

@synthesize formViewController = _formViewController;
@synthesize formTableView = _formTableView;

#pragma mark - Class register

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _cellHeightCache = [NSMutableDictionary dictionary];
        
    }
    return self;
}

-(void)dealloc
{
    _formTableView.delegate = nil;
    _formTableView.dataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//-(Class)viewControllerClassForRow:(XEFormRowObject *)row
//{
//    if(row.type != XEFormRowTypeDefault)
//    {
//        return self.controllerClassesForRowTypes[row.type] ?:
//        self.parentFormController.controllerClassesForRowTypes[row.type] ?:
//        self.controllerClassesForRowTypes[XEFormRowTypeDefault];
//    }
//    else
//    {
//        Class valueClass = row.valueClass;
//        while (valueClass != [NSObject class])
//        {
//            Class controllerClass = self.controllerClassesForRowClasses[NSStringFromClass(valueClass)] ?:
//            self.parentFormController.controllerClassesForRowClasses[NSStringFromClass(valueClass)];
//            if (controllerClass)
//            {
//                return controllerClass;
//            }
//            valueClass = [valueClass superclass];
//        }
//        return self.controllerClassesForRowTypes[XEFormRowTypeDefault];
//    }
//}

#pragma mark - forward Method



- (BOOL)respondsToSelector:(SEL)selector
{
    return [super respondsToSelector:selector] || [self.formViewController respondsToSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:self.formViewController];
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
    XEFormSectionObject *sectionObject = [self sectionAtIndex:indexPath.section];
    NSArray *sectionRows = sectionObject.rows;
    if(sectionRows.count >= indexPath.row+1)
    {
        return [sectionRows objectAtIndex:indexPath.row];
    }
    else
    {
        return nil;
    }
}

- (NSIndexPath *)indexPathForRow:(XEFormRowObject *)row
{
    NSUInteger sectionIndex = 0;
    for (XEFormSectionObject *section in self.form.sections)
    {
        NSUInteger rowIndex = [section.rows indexOfObject:row];
        if (rowIndex != NSNotFound)
        {
            return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
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



#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self numberOfSections];
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [[self sectionAtIndex:section].header description];
//}
//
//-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return [[self sectionAtIndex:section].footer description];
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfRowsInSection:section];
}

- (UITableViewCell *)cellForRow:(XEFormRowObject *)row
{
    //don't recycle cells - it would make things complicated
    Class cellClass = row.cellClass;
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

        UITableViewCellStyle style  = row.cellStyle;
        
        //don't recycle cells - it would make things complicated
        return [[cellClass alloc] initWithStyle:style reuseIdentifier:NSStringFromClass(cellClass)];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XEFormRowObject *row = [self rowForIndexPath:indexPath];
    Class cellClass = row.cellClass;
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
    XEFormBaseCell *cell = (XEFormBaseCell *)[self cellForRow:[self rowForIndexPath:indexPath]];
    if([self.formViewController isKindOfClass:[XEFormViewController class]])
    {
        // TODO: Maybe not elegance
        cell.delegate = (XEFormViewController *)(self.formViewController);
    }
    return cell;
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
    if ([self.formViewController respondsToSelector:_cmd])
    {
        return [self.formViewController tableView:tableView viewForHeaderInSection:section];
    }
    
    //handle view or class
    id header = [self sectionAtIndex:section].header;
    if ([header isKindOfClass:[UIView class]])
    {
        return header;
    }
    
    NSString *sectionHeaderStr = [[self sectionAtIndex:section].header description];
    if (sectionHeaderStr)
    {
        NSAttributedString *headerAttributedStr =
        [[NSAttributedString alloc] initWithString:sectionHeaderStr
                                        attributes:[XEFormSetting sharedSetting].headerFooterViewSetting.titleAttributes];
        XEFormHeaderFooterView *headerFooterView = [[XEFormHeaderFooterView alloc] initWithTableWidth:self.formTableView.frame.size.width text:headerAttributedStr];
        return headerFooterView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //forward to delegate
    if ([self.formViewController respondsToSelector:_cmd])
    {
        return [self.formViewController tableView:tableView heightForHeaderInSection:section];
    }
    
    //handle view or class
    UIView *header = [self sectionAtIndex:section].header;
    if ([header isKindOfClass:[UIView class]])
    {
        return header.frame.size.height ?: 2*[XEFormSetting sharedSetting].cellSetting.offsetY;
    }
    
    NSString *sectionHeaderStr = [[self sectionAtIndex:section].header description];
    if (sectionHeaderStr)
    {
        NSAttributedString *headerAttributedStr =
        [[NSAttributedString alloc] initWithString:sectionHeaderStr
                                        attributes:[XEFormSetting sharedSetting].headerFooterViewSetting.titleAttributes];
        return [XEFormHeaderFooterView heightWithMaxWidth:self.formTableView.frame.size.width Text:headerAttributedStr];
    }
    
    return 2*[XEFormSetting sharedSetting].cellSetting.offsetY;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //forward to delegate
    if ([self.formViewController respondsToSelector:_cmd])
    {
        return [self.formViewController tableView:tableView viewForFooterInSection:section];
    }
    
    //handle view or class
    id footer = [self sectionAtIndex:section].footer;
    if ([footer isKindOfClass:[UIView class]])
    {
        return footer;
    }
    
    NSString *sectionFooterStr = [[self sectionAtIndex:section].footer description];
    if (sectionFooterStr)
    {
        NSAttributedString *footerAttributedStr =
        [[NSAttributedString alloc] initWithString:sectionFooterStr
                                        attributes:[XEFormSetting sharedSetting].headerFooterViewSetting.titleAttributes];
        XEFormHeaderFooterView *headerFooterView = [[XEFormHeaderFooterView alloc] initWithTableWidth:self.formTableView.frame.size.width text:footerAttributedStr];
        return headerFooterView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //forward to delegate
    if ([self.formViewController respondsToSelector:_cmd])
    {
        return [self.formViewController tableView:tableView heightForFooterInSection:section];
    }
    
    //handle view or class
    UIView *footer = [self sectionAtIndex:section].footer;
    if ([footer isKindOfClass:[UIView class]])
    {
        return footer.frame.size.height ?: 0.01;
    }
    
    NSString *sectionFooterStr = [[self sectionAtIndex:section].footer description];
    if (sectionFooterStr)
    {
        NSAttributedString *footerAttributedStr =
        [[NSAttributedString alloc] initWithString:sectionFooterStr
                                        attributes:[XEFormSetting sharedSetting].headerFooterViewSetting.titleAttributes];
        return [XEFormHeaderFooterView heightWithMaxWidth:self.formTableView.frame.size.width Text:footerAttributedStr];
    }
    
    return 0.01;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    XEFormRowObject *row = [self rowForIndexPath:indexPath];
    
    // set form row
     ((XEFormBaseCell *)cell).row = row;
        
    //forward to delegate
    if ([self.formViewController respondsToSelector:_cmd])
    {
        [self.formViewController tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //forward to cell
    XEFormBaseCell *cell = (XEFormBaseCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(didSelectWithTableView:controller:)])
    {
        [cell didSelectWithTableView:tableView controller:[self tableViewController]];
    }
    
    //forward to delegate
    if ([self.formViewController respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [self.formViewController tableView:tableView didSelectRowAtIndexPath:indexPath];
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
    if ([self.formViewController respondsToSelector:_cmd])
    {
        [self.formViewController scrollViewWillBeginDragging:scrollView];
    }
}

#pragma mark - Getter & setter

-(void)setFormViewController:(XEFormViewController *)formViewController
{
    _formViewController = formViewController;
    
    //force table to update respondsToSelector: cache
    _formTableView.delegate = nil;
    _formTableView.dataSource = self;
}

//-(XEFormViewController *)formViewController
//{
//    if(nil == _formViewController)
//    {
//        NSString *className = [NSString stringWithFormat:@"%@ViewController", NSStringFromClass([self class])];
//        Class subViewControlloerClass = NSClassFromString(className);
//        if (subViewControlloerClass == nil)
//        {
//            // create class through runtime
//            subViewControlloerClass = objc_allocateClassPair(NSClassFromString(@"XEFormViewController"), [className UTF8String], 0);
//        }
//        XEFormViewController *fromViewController = [[subViewControlloerClass alloc] init];
//        _formViewController = fromViewController;
//    }
//    return _formViewController;
//}

-(UITableView *)formTableView
{
    if (nil == _formTableView)
    {
        if ([_formViewController respondsToSelector:@selector(customizeFormTableView)])
        {
            _formTableView = [_formViewController customizeFormTableView];
        }
        
        if(nil == _formTableView)
        {
            UITableView *formTableView =
            [[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                         style:UITableViewStyleGrouped];
            if ([formTableView respondsToSelector:@selector(cellLayoutMarginsFollowReadableWidth)])
            {
                formTableView.cellLayoutMarginsFollowReadableWidth = NO;
            }
            _formTableView = formTableView;
        }
        
        _formTableView.dataSource = self;
        _formTableView.delegate = self;
        _formTableView.editing = YES;
        _formTableView.allowsSelectionDuringEditing = YES;
        _formTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _formTableView;
}

-(void)setFormTableView:(UITableView *)formTableView
{
    _formTableView = formTableView;
    

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
