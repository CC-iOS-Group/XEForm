//
//  XEFormObject.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>

#import "XEForm.h"

@class XEFormController;

@interface XEFormRowObject : NSObject

#pragma mark - Property

@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, weak) XEForm *form;
@property (nonatomic, strong) id value;
@property (nonatomic, strong) id defaultValue;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) Class valueClass;
@property (nonatomic, strong) id placeholder;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) id header;
@property (nonatomic, strong) id footer;
@property (nonatomic, copy) id (^valueTransformer)(id input);
@property (nonatomic, copy) id (^reverseValueTransformer)(id input);

#pragma mark UI
@property (nonatomic, strong) Class cellClass;
@property (nonatomic, strong) id viewController;
@property (nonatomic, strong) NSMutableDictionary *cellConfig;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isSortable;
@property (nonatomic, assign) BOOL isInline;
@property (nonatomic, copy) void (^action)(id sender);
@property (nonatomic, strong) id segue;

#pragma mark - Method
+ (instancetype)objectWithProperty:(objc_property_t)property;
- (instancetype)initWithKey:(NSString *)key Class:(Class)class type:(NSString *)type;
- (void)configWithForm:(XEForm *)form;

- (NSString *)rowDescription;

// TODO: Util category
- (BOOL)isCollectionType;

// TODO: Options methods should move to category
- (NSUInteger)optionCount;
- (id)optionAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfOption:(id)option;
- (NSString *)optionDescriptionAtIndex:(NSUInteger)index;
- (void)setOptionSelected:(BOOL)selected atIndex:(NSUInteger)index;
- (BOOL)isOptionSelectedAtIndex:(NSUInteger)index;


@end
