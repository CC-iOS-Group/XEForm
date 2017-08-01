//
//  XEFormDynamicViewController.m
//  Pods
//
//  Created by 丁明 on 2017/7/31.
//
//

#import "XEFormSetting.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import "XEFormRowObject.h"
#import "XEFormController.h"
#import "XEFormControllerDelegate.h"
#import "XEFormRowViewControllerDelegate.h"

@implementation XEFormHeaderFooterViewSetting

@end

@interface XEFormSetting()



@end


static CGFloat kDefault_OffsetX = 15.;
static CGFloat kDefault_OffsetY = 7.5;

@implementation XEFormSetting

+ (instancetype)sharedSetting
{
    static dispatch_once_t onceToken;
    static XEFormSetting *sharedSetting;
    dispatch_once(&onceToken, ^{
        sharedSetting = [[XEFormSetting alloc] init];
    });
    return sharedSetting;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setDefaultSetting];
    }
    return self;
}

- (void)setDefaultSetting
{
    XEFormHeaderFooterViewSetting *headerFooterViewSetting = [XEFormHeaderFooterViewSetting new];
    headerFooterViewSetting.edgeInsets = UIEdgeInsetsMake(kDefault_OffsetY, kDefault_OffsetX, kDefault_OffsetY, kDefault_OffsetX);
    
    
    
    
    
    
    self.headerFooterViewSetting = headerFooterViewSetting;
}

#pragma mark - Getter & setter

-(void)setBaseViewController:(Class)BaseViewController
{
    _BaseViewController = BaseViewController;
    // Hack to set super class
    class_setSuperclass(NSClassFromString(@"XEFormViewController"), _BaseViewController);
}


@end
