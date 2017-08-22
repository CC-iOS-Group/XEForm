//
//  XEFormController.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import <Foundation/Foundation.h>

#import "XEFormObject.h"
#import "XEFormControllerDelegate.h"

@class XEFormRowObject, XEFormViewController;

@interface XEFormController : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *formTableView;
@property (nonatomic, strong) XEFormController *parentFormController;
@property (nonatomic, weak) XEFormViewController *formViewController;
@property (nonatomic, strong) XEFormObject *form;

@property (nonatomic, strong) NSMutableDictionary *cellHeightCache;
@property (nonatomic, strong) NSMutableDictionary *controllerClassesForRowTypes;
@property (nonatomic, strong) NSMutableDictionary *controllerClassesForRowClasses;
@property (nonatomic, assign) UIEdgeInsets originalTableContentInset;



- (void)performAction:(SEL)selector withSender:(id)sender;
- (UIViewController *)tableViewController;

@end
