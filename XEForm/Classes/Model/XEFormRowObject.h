//
//  XEFormObject.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>

#import "XEFormObject.h"
#import "XEFormSetting.h"

@class XEFormController;

@interface XEFormRowObject : NSObject

#pragma mark - Property

@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, weak) XEFormObject *form;
@property (nonatomic, strong) id value;
@property (nonatomic, strong) id defaultValue;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) Class valueClass;
@property (nonatomic, strong) id placeholder;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) id (^valueTransformer)(id input);
@property (nonatomic, copy) id (^reverseValueTransformer)(id input);
@property (nonatomic, copy) NSMutableDictionary *userInfo;

#pragma mark UI
@property (nonatomic, strong) Class cellClass;
@property (nonatomic, copy) NSString *logoStr;
@property (nonatomic, strong) id header;
@property (nonatomic, strong) id footer;
@property (nonatomic, strong) id viewController;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSAttributedString *attributedTitle;
@property (nonatomic, assign) BOOL isSortable;
@property (nonatomic, assign) BOOL isInline;
@property (nonatomic, copy) void (^action)(id sender, void(^successBlock)(), void(^failureBlock)(NSError *error));
@property (nonatomic, strong) id segue;
@property (nonatomic, strong) XEFormSpecialCellSetting *cellSetting;

#pragma mark - Method
+ (instancetype)objectWithProperty:(objc_property_t)property;
- (instancetype)initWithKey:(NSString *)key Class:(Class)class type:(NSString *)type;
- (void)configWithForm:(XEFormObject *)form;

- (NSString *)valueDescription:(id)value;
- (NSString *)rowDescription;
- (NSAttributedString *)attributedDescription;

- (BOOL)isIndexedType;
- (BOOL)isCollectionType;
- (BOOL)isOrderedCollectionType;
- (BOOL)isSubform;

// TODO: Options methods should move to category
- (NSUInteger)optionCount;
- (id)optionAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfOption:(id)option;
- (NSString *)optionDescriptionAtIndex:(NSUInteger)index;
- (void)setOptionSelected:(BOOL)selected atIndex:(NSUInteger)index;
- (BOOL)isOptionSelectedAtIndex:(NSUInteger)index;

- (Class)subViewControllerClass;

@end
