//
//  XEFormObject.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import <Foundation/Foundation.h>

#import "XEFormDelegate.h"

#import <objc/runtime.h>

@class XEFormController;

@interface XEFormObject : NSObject

#pragma mark - Property

@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, weak, readonly) id<XEFormDelegate> form;
@property (nonatomic, strong, readonly) id value;
@property (nonatomic, strong, readonly) NSArray *options;
@property (nonatomic, strong) Class valueClass;
@property (nonatomic, strong, readonly) id placeholder;
@property (nonatomic, copy, readonly) NSString *type;

@property (nonatomic, strong) id defaultValue;
@property (nonatomic, strong) id header;
@property (nonatomic, strong) id footer;

@property (nonatomic, weak) XEFormController *formController;
@property (nonatomic, strong) NSMutableDictionary *cellConfig;

#pragma mark - Method

+ (NSArray *)objectsWithForm:(id<XEFormDelegate>)form controller:(XEFormController *)formController;

+ (instancetype)objectWithProperty:(objc_property_t)property;

- (instancetype)initWithForm:(id<XEFormDelegate>)form controller:(XEFormController *)formController attributes:(NSDictionary *)attributes;

- (NSUInteger)optionCount;
- (id)optionAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfOption:(id)option;
- (NSString *)optionDescriptionAtIndex:(NSUInteger)index;
- (void)setOptionSelected:(BOOL)selected atIndex:(NSUInteger)index;
- (BOOL)isOptionSelectedAtIndex:(NSUInteger)index;


@end
