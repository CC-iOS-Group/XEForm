//
//  NSObject+XEForm.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import <Foundation/Foundation.h>

#import "XEFormDelegate.h"

@class XEFormObject;

@interface NSObject(XEForm)<XEFormDelegate>

- (NSString *)formDescription;

- (NSArray<XEFormObject *> *)getFormObjects;

@end
