//
//  XEFormSectionObject.h
//  Pods
//
//  Created by 丁明 on 2017/6/28.
//
//

#import <Foundation/Foundation.h>

@class XEFormController, XEForm, XEFormRowObject;

@interface XEFormSectionObject : NSObject

@property (nonatomic, strong) id header;
@property (nonatomic, strong) id footer;
@property (nonatomic, strong) NSMutableArray<XEFormRowObject *> *rows;
@property (nonatomic, assign) BOOL isSortable;

+ (NSArray *)sectionsWithForm:(XEForm *)form;

@end
