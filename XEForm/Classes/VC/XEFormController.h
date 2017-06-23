//
//  XEFormController.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import <Foundation/Foundation.h>

#import "XEFormDelegate.h"

@class XEFormRow;

@protocol XEFormControllerDelegate <UITableViewDelegate>


@end

@interface XEFormController : NSObject

@property (nonatomic, strong) UITableView *formTableView;
@property (nonatomic, strong) XEFormController *parentFormController;
@property (nonatomic, strong) id<XEFormControllerDelegate> delegate;
@property (nonatomic, strong) id<XEFormDelegate> form;

- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfFieldsInSection:(NSUInteger)section;
- (XEFormRow *)rowForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForRow:(XEFormRow *)row;
- (void)enumerateFieldsWithBlock:(void (^)(XEFormRow *row, NSIndexPath *indexPath))block;

- (Class)cellClassForRow:(XEFormRow *)row;
- (void)registerDefaultFieldCellClass:(Class)cellClass;
- (void)registerCellClass:(Class)cellClass forFieldType:(NSString *)fieldType;
- (void)registerCellClass:(Class)cellClass forFieldClass:(Class)fieldClass;

- (Class)viewControllerClassForRow:(XEFormRow *)row;
- (void)registerDefaultViewControllerClass:(Class)controllerClass;
- (void)registerViewControllerClass:(Class)controllerClass forFieldType:(NSString *)fieldType;
- (void)registerViewControllerClass:(Class)controllerClass forFieldClass:(Class)fieldClass;

- (void)performAction:(SEL)selector withSender:(id)sender;
- (UIViewController *)tableViewController;

@end
