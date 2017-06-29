//
//  XETemplateForm.h
//  Pods
//
//  Created by 丁明 on 2017/6/28.
//
//

#import <Foundation/Foundation.h>

#import "XEForm.h"

@class XEFormRowObject;

@interface XETemplateForm : XEForm

//@property (nonatomic, strong) XEFormRowObject *row;
@property (nonatomic, strong) NSMutableArray *values;

- (instancetype)initWithRow:(XEFormRowObject *)row;

- (void)addNewRowAtIndex:(NSInteger)index;

- (void)removeRowAtIndex:(NSUInteger)index;

- (void)moveFieldAtIndex:(NSUInteger)index1 toIndex:(NSUInteger)index2;

@end
