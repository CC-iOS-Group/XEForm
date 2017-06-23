//
//  TestForm.h
//  XEForm
//
//  Created by 丁明 on 2017/6/23.
//  Copyright © 2017年 xenobladeX. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <XEForm/XEFormDelegate.h>

#import "TestForm2.h"

@interface TestForm : NSObject<XEFormDelegate>

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) TestForm2 *test;

//@property (nonatomic, strong) NSArray *rows;

@end
