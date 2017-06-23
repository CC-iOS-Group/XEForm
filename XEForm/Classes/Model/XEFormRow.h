//
//  XEFormRow.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import <Foundation/Foundation.h>

#import "XEFormDelegate.h"

@class XEFormObject, XEFormController;

@interface XEFormRow : NSObject

@property (nonatomic, weak, readonly) XEFormObject *formObject;
@property (nonatomic, strong) Class cellClass;
@property (nonatomic, copy, readonly) NSString *title;

@property (nonatomic, copy, readonly) void (^action)(id sender);
@property (nonatomic, strong, readonly) id segue;
@property (nonatomic, strong, readonly) id viewController;

@property (nonatomic, weak) XEFormController *formController;

@end
