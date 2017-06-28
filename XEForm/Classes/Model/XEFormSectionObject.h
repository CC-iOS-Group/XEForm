//
//  XEFormSectionObject.h
//  Pods
//
//  Created by 丁明 on 2017/6/28.
//
//

#import <Foundation/Foundation.h>

#import "XEFormDelegate.h"

@class XEFormController;

@interface XEFormSectionObject : NSObject

@property (nonatomic, weak) id<XEFormDelegate> form;
@property (nonatomic, strong) id header;
@property (nonatomic, strong) id footer;
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, assign) BOOL isSortable;

+ (NSArray *)sectionsWithForm:(id<XEFormDelegate>)form controller:(XEFormController *)formController;

@end
