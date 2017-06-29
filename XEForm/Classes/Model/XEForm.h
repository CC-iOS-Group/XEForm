//
//  XEForm.h
//  Pods
//
//  Created by 丁明 on 2017/6/29.
//
//

#import <Foundation/Foundation.h>

@class  XEFormRowObject ,XEFormSectionObject, XEFormController;

@protocol XEFormDelegates <NSObject>

@optional

@property (nonatomic, strong) XEFormRowObject *row;



@end

@interface XEForm : NSObject<XEFormDelegates>

@property (nonatomic, strong, readonly) NSArray<XEFormRowObject *> *propertyRows;

@property (nonatomic, strong) NSArray<XEFormRowObject *> *rows;

@property (nonatomic, strong, readonly) NSArray<XEFormSectionObject *> *sections;

@property (nonatomic, weak)  XEFormController *formController;


#pragma mark - Public method

- (BOOL)canGetValueForKey:(NSString *)key;
- (BOOL)canSetValueForKey:(NSString *)key;

- (void)addNewRowAtIndex:(NSInteger)index;
- (void)removeRowAtIndex:(NSUInteger)index;
- (void)moveFieldAtIndex:(NSUInteger)index1 toIndex:(NSUInteger)index2;

#pragma mark - Customizing

/**
 Only used to Ignore the property you don't want to count in,
 won't influence the 'rows' property and what declared in 'rows'
 
 @return The property key you don't want to count in
 */
- (NSSet<NSString *> *)excludeProperties;






@end
