//
//  XEFormNavigationAccessoryView.h
//  Pods
//
//  Created by 丁明 on 2017/8/16.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XEFormNavigationDirection) {
    XEFormNavigationDirectionPrevious = 0,
    XEFormNavigationDirectionNext
};

@interface XEFormNavigationAccessoryView : UIToolbar

@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

@end
