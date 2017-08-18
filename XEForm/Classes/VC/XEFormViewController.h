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
#import "XEFormRowCellDelegate.h"
#import "XEFormNavigationAccessoryView.h"

@class XEFormController;

@interface XEFormViewController : UIViewController<XEFormRowViewControllerDelegate, XEFormControllerDelegate, XEFormRowCellDelegate>


@property (nonatomic, strong) XEFormNavigationAccessoryView *navigationAccessoryView;

@end
