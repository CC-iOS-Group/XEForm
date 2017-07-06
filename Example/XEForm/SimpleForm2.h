//
//  SimpleForm2.h
//  XEForm
//
//  Created by 丁明 on 2017/6/23.
//  Copyright © 2017年 xenobladeX. All rights reserved.
//

#import "SimpleForm.h"

#import <XEForm/XEForm.h>

@interface SimpleForm2 : XEForm

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) BOOL hasLogin;
@property (nonatomic, strong) NSDate *birthday;

@property (nonatomic, strong) UIImage *image;

@end
