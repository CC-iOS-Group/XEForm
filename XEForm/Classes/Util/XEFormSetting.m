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
#import "UIImage+XEForm.h"
#import "XEFormConst.h"

@implementation XEFormHeaderFooterViewSetting

@end

@implementation XEFormCommonCellSetting

@synthesize cellHeight = _cellHeight;

-(CGFloat)cellHeight
{
    return _cellHeight;
}

@end

@implementation XEFormSpecialCellSetting


-(CGFloat)cellHeight
{
    if (_cellHeight == 0)
    {
        return [XEFormSetting sharedSetting].cellSetting.cellHeight;
    }
    return _cellHeight;
}

@end

@interface XEFormSetting()



@end

#define kDefault_headerFooterTitleColor             [UIColor grayColor]
#define kDefault_cellDescriptionColor               [UIColor grayColor]
#define kDefault_separatorColor                     [UIColor lightGrayColor]
#define kDefault_indicatorViewTintColor             [UIColor lightGrayColor]

static CGFloat kDefault_OffsetX =                   15.;
static CGFloat kDefault_OffsetY =                   7.5;
static CGFloat kDefault_logoSize =                  20.;
static CGFloat kDefault_cellHeight =                44.;

static CGFloat kDefault_headerFooterTitleFont =     13.;
static CGFloat kDefault_cellTitleFont =             15.;
static CGFloat kDefault_cellDescriptionFont =       13.;
static CGFloat kDefault_cellTextFiledFont =         15.;
static CGFloat kDefault_cellTextViewFont =          15.;

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
    headerFooterViewSetting.titleAttributes = @{
                                                NSFontAttributeName: [UIFont systemFontOfSize:kDefault_headerFooterTitleFont],
                                                NSForegroundColorAttributeName : kDefault_headerFooterTitleColor,
                                                };
    
    XEFormCommonCellSetting *cellSetting = [XEFormCommonCellSetting new];
    cellSetting.separatorColor = kDefault_separatorColor;
    cellSetting.separatorHeight = 0.5;
    cellSetting.offsetX = kDefault_OffsetX;
    cellSetting.offsetY = kDefault_OffsetY;
    cellSetting.indicatorImage = [UIImage disclosureIndicatorImageWithIndicatorSize:6.];
    cellSetting.checkMarkImage = [UIImage checkMarkWithCheckMarkSize:CGSizeMake(14., 7.)];
    cellSetting.indicatorViewTintColor = kDefault_indicatorViewTintColor;
    cellSetting.titleAttributes = @{
                                                NSFontAttributeName: [UIFont systemFontOfSize:kDefault_cellTitleFont],
                                                };
    
    cellSetting.descriptionAttributes = @{
                                                NSFontAttributeName: [UIFont systemFontOfSize:kDefault_cellDescriptionFont],
                                                NSForegroundColorAttributeName : kDefault_cellDescriptionColor,
                                                };
    cellSetting.textFieldAttributes = @{
                                        NSFontAttributeName: [UIFont systemFontOfSize:kDefault_cellTextFiledFont],
                                        };
    cellSetting.textViewAttributes = @{
                                        NSFontAttributeName: [UIFont systemFontOfSize:kDefault_cellTextViewFont],
                                        };
    
    
    cellSetting.logoSize = CGSizeMake(kDefault_logoSize, kDefault_logoSize);
    cellSetting.cellHeight = kDefault_cellHeight;
    
    self.headerFooterViewSetting = headerFooterViewSetting;
    self.cellSetting = cellSetting;
    self.cellClassesForRowTypes = [@{
                                 XEFormRowTypeDefault: NSClassFromString(@"XEFormDefaultCell"),
                                 XEFormRowTypeText: NSClassFromString(@"XEFormTextFieldCell"),
                                 XEFormRowTypeLongText: NSClassFromString(@"XEFormTextViewCell"),
                                 XEFormRowTypeURL: NSClassFromString(@"XEFormTextFieldCell"),
                                 XEFormRowTypeEmail: NSClassFromString(@"XEFormTextFieldCell"),
                                 XEFormRowTypePhone: NSClassFromString(@"XEFormTextFieldCell"),
                                 XEFormRowTypePassword: NSClassFromString(@"XEFormTextFieldCell"),
                                 XEFormRowTypeNumber: NSClassFromString(@"XEFormTextFieldCell"),
                                 XEFormRowTypeFloat: NSClassFromString(@"XEFormTextFieldCell"),
                                 XEFormRowTypeInteger: NSClassFromString(@"XEFormTextFieldCell"),
                                 XEFormRowTypeUnsigned: NSClassFromString(@"XEFormTextFieldCell"),
                                 XEFormRowTypeBoolean: NSClassFromString(@"XEFormSwitchCell"),
                                 XEFormRowTypeDate: NSClassFromString(@"XEFormDatePickerCell"),
                                 XEFormRowTypeTime: NSClassFromString(@"XEFormDatePickerCell"),
                                 XEFormRowTypeDateTime: NSClassFromString(@"XEFormDatePickerCell"),
                                 XEFormRowTypeImage: NSClassFromString(@"XEFormImagePickerCell"),
                                 
                                 
                                 } mutableCopy];
    self.cellClassesForRowClasses = [@{
                                   
                                   } mutableCopy];
    self.controllerClassesForRowTypes = [@{
                                       XEFormRowTypeDefault: NSClassFromString(@"XEFormViewController"),
                                       } mutableCopy];
    self.controllerClassesForRowClasses = [NSMutableDictionary dictionary];
}

#pragma mark - Getter & setter

-(void)setBaseViewController:(Class)BaseViewController
{
    _BaseViewController = BaseViewController;
    // Hack to set super class
    class_setSuperclass(NSClassFromString(@"XEFormViewController"), _BaseViewController);
}

@end
