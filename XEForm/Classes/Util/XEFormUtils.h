//
//  XEFormUtils.h
//  Pods
//
//  Created by 丁明 on 2017/6/23.
//
//

#import <Foundation/Foundation.h>

#import "XEFormConst.h"
#import "XEFormRowObject.h"
#import "XEFormSetting.h"

#import <objc/runtime.h>

#pragma mark - UI

CGFloat XEFormLabelMinFontSize(UILabel *label);

void XEFormLabelSetMinFontSize(UILabel *label, CGFloat fontSize);

#pragma mark - Data

Class XEFormClassFromString(NSString *className);

BOOL XEFormRowObjectValueWithProperty(objc_property_t property, NSString **key, Class *rowValueClass, NSString **type);

BOOL isDifferentString(NSString *str1, NSString *str2);
