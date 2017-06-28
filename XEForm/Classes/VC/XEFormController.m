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
        _cellClassesForFieldTypes = [@{
                                       XEFormRowTypeDefault: NSClassFromString(@"XEFormDefaultCell"),
                                       XEFormRowTypeText: NSClassFromString(@"XEFormTextFieldCell"),
//                                       XEFormRowTypeLongText: [FXFormTextViewCell class],
                                       XEFormRowTypeURL: NSClassFromString(@"XEFormTextFieldCell"),
                                       XEFormRowTypeEmail: NSClassFromString(@"XEFormTextFieldCell"),
                                       XEFormRowTypePhone: NSClassFromString(@"XEFormTextFieldCell"),
//                                       XEFormRowTypePassword: [FXFormTextFieldCell class],
//                                       XEFormRowTypeNumber: [FXFormTextFieldCell class],
//                                       XEFormRowTypeFloat: [FXFormTextFieldCell class],
//                                       XEFormRowTypeInteger: [FXFormTextFieldCell class],
//                                       XEFormRowTypeUnsigned: [FXFormTextFieldCell class],
                                       XEFormRowTypeBoolean: NSClassFromString(@"XEFormSwitchCell"),
//                                       XEFormRowTypeDate: [FXFormDatePickerCell class],
//                                       XEFormRowTypeTime: [FXFormDatePickerCell class],
//                                       XEFormRowTypeDateTime: [FXFormDatePickerCell class],
//                                       XEFormRowTypeImage: [FXFormImagePickerCell class],
                                       
                                       
                                       
                                       
                                       
                                       } mutableCopy];
        _cellClassesForFieldClasses = [@{
                                         
                                         } mutableCopy];
        _controllerClassesForFieldTypes = [@{
                                             XEFormRowTypeDefault: [XEFormViewController class],
                                             } mutableCopy];
        _controllerClassesForFieldClasses = [NSMutableDictionary dictionary];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

-(void)dealloc
{
    NSLog(@"Form controller has dealloc");
    
    _formTableView.delegate = nil;
    _formTableView.dataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(Class)cellClassForRow:(XEFormRowObject *)row
{
    if (row.type != XEFormRowTypeDefault)
    {
        return self.cellClassesForFieldTypes[row.type] ? :
        self.parentFormController.cellClassesForFieldTypes[row.type] ? :
        self.cellClassesForFieldTypes[XEFormRowTypeDefault];
    }
    else
    {
        Class valueClass = row.valueClass;
        while (valueClass && valueClass != [NSObject class]) {
            Class cellClass = self.cellClassesForFieldClasses[NSStringFromClass(valueClass)] ? :
            self.parentFormController.cellClassesForFieldClasses[NSStringFromClass(valueClass)];
            if (cellClass)
            {
                return cellClass;
            }
            valueClass = [valueClass superclass];
        }
        return self.cellClassesForFieldTypes[XEFormRowTypeDefault];
    }
}

- (void)registerDefaultFieldCellClass:(Class)cellClass
{
    NSParameterAssert([cellClass conformsToProtocol:@protocol(XEFormRowCellDelegate)]);
    if(cellClass) [self.cellClassesForFieldTypes setDictionary:@{XEFormRowTypeDefault: cellClass}];
}

- (void)registerCellClass:(Class)cellClass forRowType:(NSString *)rowType
{
    NSParameterAssert([cellClass conformsToProtocol:@protocol(XEFormRowCellDelegate)]);
    if(rowType) self.cellClassesForFieldTypes[rowType] = cellClass;
}

- (void)registerCellClass:(Class)cellClass forRowClass:(__unsafe_unretained Class)rowClass
{
    NSParameterAssert([cellClass conformsToProtocol:@protocol(XEFormRowCellDelegate)]);
    if(rowClass) self.cellClassesForFieldClasses[NSStringFromClass(rowClass)] = cellClass;
}

-(Class)viewControllerClassForRow:(XEFormRowObject *)row
{
    if(row.type != XEFormRowTypeDefault)
    {
        return self.controllerClassesForFieldTypes[row.type] ?:
        self.parentFormController.controllerClassesForFieldTypes[row.type] ?:
        self.controllerClassesForFieldTypes[XEFormRowTypeDefault];
    }
    else
    {
        Class valueClass = row.valueClass;
        while (valueClass != [NSObject class])
        {
            Class controllerClass = self.controllerClassesForFieldClasses[NSStringFromClass(valueClass)] ?:
            self.parentFormController.controllerClassesForFieldClasses[NSStringFromClass(valueClass)];
            if (controllerClass)
            {
                return controllerClass;
            }
            valueClass = [valueClass superclass];
        }
        return self.controllerClassesForFieldTypes[XEFormRowTypeDefault];
    }
}

- (void)registerDefaultViewControllerClass:(Class)controllerClass
{
    NSParameterAssert([controllerClass conformsToProtocol:@protocol(XEFormRowViewControllerDelegate)]);
    if(controllerClass) [self.controllerClassesForFieldTypes setDictionary:@{XEFormRowTypeDefault: controllerClass}];
}

- (void)registerViewControllerClass:(Class)controllerClass forRowType:(NSString *)rowType
{
    NSParameterAssert([controllerClass conformsToProtocol:@protocol(XEFormRowViewControllerDelegate)]);
    if(rowType) self.controllerClassesForFieldTypes[rowType] = controllerClass;
}

- (void)registerViewControllerClass:(Class)controllerClass forRowClass:(__unsafe_unretained Class)rowClass
{
    NSParameterAssert([controllerClass conformsToProtocol:@protocol(XEFormRowViewControllerDelegate)]);
    if(rowClass) self.controllerClassesForFieldClasses[NSStringFromClass(rowClass)] = controllerClass;
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
    return [self.sections count];
}

- (XEFormSectionObject *)sectionAtIndex:(NSUInteger)index
{
    return self.sections[index];
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
    for (XEFormSectionObject *section in self.sections)
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
    for (XEFormSectionObject *section in self.sections)
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


#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate


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

-(void)setForm:(id<XEFormDelegate>)form
{
    self.sections = [XEFormSectionObject sectionsWithForm:form controller:self];
    _form = form;
}



@end
