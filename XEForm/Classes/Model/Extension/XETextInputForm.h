//
//  XETextInputForm.h
//  Pods
//
//  Created by 丁明 on 2017/8/4.
//
//

#import "XEFormObject.h"

@interface XETextInputForm : XEFormObject

@property (nonatomic, copy) NSString *text;

- (XEFormRowObject *)textRow;

- (NSString *)type;

- (void)setType:(NSString *)type;

@end
