//
//  SimpleForm.h
//  XEForm
//
//  Created by 丁明 on 2017/6/23.
//  Copyright © 2017年 xenobladeX. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <XEForm/XEForm.h>

typedef NS_ENUM(NSInteger, Gender)
{
    GenderMale = 0,
    GenderFemale,
    GenderOther
};

typedef NS_OPTIONS(NSInteger, Interests)
{
    InterestComputers = 1 << 0,
    InterestSocializing = 1 << 1,
    InterestSports = 1 << 2
};

@interface SimpleForm2 : XEForm

@property (nonatomic, assign) BOOL test;

@property (nonatomic, assign) BOOL test2;

@property (nonatomic, assign) Gender gender;

@property (nonatomic, assign) Interests interests;

@end
