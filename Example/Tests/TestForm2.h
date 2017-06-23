//
//  TestForm2.h
//  XEForm
//
//  Created by 丁明 on 2017/6/23.
//  Copyright © 2017年 xenobladeX. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <XEForm/XEFormDelegate.h>

#import "NSObject+XEForm.h"

@interface TestForm2 : NSObject<XEFormDelegate>

@property (nonatomic, assign) int age;

@property (nonatomic, strong) NSArray<NSString *> *games;

@end
