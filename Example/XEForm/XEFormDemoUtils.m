//
//  XEFormDemoUtils.m
//  XEForm
//
//  Created by 丁明 on 2017/8/16.
//  Copyright © 2017年 xenobladeX. All rights reserved.
//

#import "XEFormDemoUtils.h"

BOOL isDifferentString(NSString *str1, NSString *str2)
{
    if(str1)
    {
        if(str2)
        {
            return ![str1 isEqualToString:str2];
        }
        else
        {
            return YES;
        }
    }
    else
    {
        if(str2)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

