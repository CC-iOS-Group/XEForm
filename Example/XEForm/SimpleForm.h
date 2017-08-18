//
//  SimpleForm2.h
//  XEForm
//
//  Created by 丁明 on 2017/6/23.
//  Copyright © 2017年 xenobladeX. All rights reserved.
//

#import "SimpleForm2.h"
#import "SimpleForm3.h"

@class SimpleForm3;

@interface SimpleForm : XEFormObject

@property (nonatomic, strong) SimpleForm2 *secondForm;

@property (nonatomic, strong) SimpleForm3 *secondForm2;

@property (nonatomic, strong) XETextInputForm *textInput;

@property (nonatomic, strong) NSString *textInline;

@property (nonatomic, strong) NSString *textView;

@property (nonatomic, strong) XETextInputForm *subTextView;

@end
