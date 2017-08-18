//
//  UIView+XEForm.h
//  Pods
//
//  Created by 丁明 on 2017/8/16.
//
//

#import <UIKit/UIKit.h>

@class XEFormBaseCell;

@interface UIView(XEForm)

- (UIView *)findFirstResponder;

- (XEFormBaseCell *)formCell;

@end
