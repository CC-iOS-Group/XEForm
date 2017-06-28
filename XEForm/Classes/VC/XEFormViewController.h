//
//  XEFormViewController.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import <UIKit/UIKit.h>

#import "XEFormControllerDelegate.h"
#import "XEFormRowViewControllerDelegate.h"
#import "XEFormController.h"


@interface XEFormViewController : UIViewController<XEFormRowViewControllerDelegate, XEFormControllerDelegate>

@property (nonatomic, strong, readonly) XEFormController *formController;

@property (nonatomic, strong) UITableView *formTableView;


@end
