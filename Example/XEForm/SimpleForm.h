//
//  SimpleForm2.h
//  XEForm
//
//  Created by 丁明 on 2017/6/23.
//  Copyright © 2017年 xenobladeX. All rights reserved.
//

#import "SimpleForm2.h"
#import "SimpleForm3.h"

#import <XEForm/XEForm.h>

@class SimpleForm3;

@interface SimpleForm : XEForm

@property (nonatomic, strong) SimpleForm2 *secondForm;

@property (nonatomic, strong) SimpleForm3 *secondForm2;

@end
