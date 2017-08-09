//
//  XETextInputForm.h
//  Pods
//
//  Created by 丁明 on 2017/8/4.
//
//

#import <XEForm/XEForm.h>

@interface XETextInputForm : XEForm

@property (nonatomic, copy) NSString *text;

- (XEFormRowObject *)textRow;

@end
