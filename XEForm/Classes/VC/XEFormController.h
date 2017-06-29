//
//  XEFormController.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import <Foundation/Foundation.h>

#import "XEForm.h"
#import "XEFormControllerDelegate.h"

@class XEFormRowObject;

@interface XEFormController : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *formTableView;
@property (nonatomic, strong) XEFormController *parentFormController;
@property (nonatomic, weak) id<XEFormControllerDelegate> delegate;
@property (nonatomic, strong) XEForm *form;

@property (nonatomic, strong) NSMutableDictionary *cellHeightCache;
@property (nonatomic, strong) NSMutableDictionary *cellClassesForFieldTypes;
@property (nonatomic, strong) NSMutableDictionary *cellClassesForFieldClasses;
@property (nonatomic, strong) NSMutableDictionary *controllerClassesForFieldTypes;
@property (nonatomic, strong) NSMutableDictionary *controllerClassesForFieldClasses;
@property (nonatomic, assign) UIEdgeInsets originalTableContentInset;

- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;
- (XEFormRowObject *)rowForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForRow:(XEFormRowObject *)row;
- (void)enumerateRowsWithBlock:(void (^)(XEFormRowObject *row, NSIndexPath *indexPath))block;

- (Class)cellClassForRow:(XEFormRowObject *)row;
- (void)registerDefaultRowCellClass:(Class)cellClass;
- (void)registerCellClass:(Class)cellClass forRowType:(NSString *)rowType;
- (void)registerCellClass:(Class)cellClass forRowClass:(Class)rowClass;

- (Class)viewControllerClassForRow:(XEFormRowObject *)row;
- (void)registerDefaultViewControllerClass:(Class)controllerClass;
- (void)registerViewControllerClass:(Class)controllerClass forRowType:(NSString *)rowType;
- (void)registerViewControllerClass:(Class)controllerClass forRowClass:(Class)rowClass;

- (void)performAction:(SEL)selector withSender:(id)sender;
- (UIViewController *)tableViewController;

@end
