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

@class XEFormRowObject, XEFormViewController;

@interface XEFormController : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *formTableView;
@property (nonatomic, strong) XEFormController *parentFormController;
@property (nonatomic, weak) XEFormViewController *formViewController;
@property (nonatomic, strong) XEForm *form;

@property (nonatomic, strong) NSMutableDictionary *cellHeightCache;
@property (nonatomic, strong) NSMutableDictionary *controllerClassesForRowTypes;
@property (nonatomic, strong) NSMutableDictionary *controllerClassesForRowClasses;
@property (nonatomic, assign) UIEdgeInsets originalTableContentInset;

- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;
- (XEFormRowObject *)rowForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForRow:(XEFormRowObject *)row;
- (void)enumerateRowsWithBlock:(void (^)(XEFormRowObject *row, NSIndexPath *indexPath))block;

- (void)performAction:(SEL)selector withSender:(id)sender;
- (UIViewController *)tableViewController;

@end
