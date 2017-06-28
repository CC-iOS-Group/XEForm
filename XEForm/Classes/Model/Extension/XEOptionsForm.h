//
//  XEOptionsForm.h
//  Pods
//
//  Created by 丁明 on 2017/6/28.
//
//

#import <Foundation/Foundation.h>

#import "XEFormDelegate.h"

@class XEFormRowObject;
/**
 an options select extention of XEForm Use index as key
 */
@interface XEOptionsForm : NSObject<XEFormDelegate>

@property (nonatomic, strong) XEFormRowObject *row;

- (instancetype)initWithRow:(XEFormRowObject *)row;

@end
