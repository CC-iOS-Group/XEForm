//
//  NSObject+XEForm.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import <Foundation/Foundation.h>

#import "XEFormDelegate.h"

@class XEFormObject, XEFormController;

@interface NSObject(XEForm)<XEFormDelegate>

- (NSArray<XEFormObject *> *)getRowObjectsFromClass;

- (BOOL)canGetValueForKey:(NSString *)key;

- (BOOL)canSetValueForKey:(NSString *)key;

@end
