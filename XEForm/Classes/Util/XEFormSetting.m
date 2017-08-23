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

@interface XEFormCommonCellSetting ()
{
    XEFormPickerType _pickerType;
    UITableViewCellStyle _cellStyle;
}

@end

@implementation XEFormCommonCellSetting

@synthesize cellHeight = _cellHeight;

-(CGFloat)cellHeight
{
    return _cellHeight;
}

-(XEFormPickerType)pickerType
{
    return _pickerType;
}

-(void)setPickerType:(XEFormPickerType)pickerType
{
    _pickerType = pickerType;
}

-(UITableViewCellStyle)cellStyle
{
    return _cellStyle;
}
-(void)setCellStyle:(UITableViewCellStyle)cellStyle
{
    _cellStyle = cellStyle;
}

@end

@interface XEFormSpecialCellSetting ()
{
    NSNumber *_pickerTypeNum;
    NSNumber *_cellStyleNum;
}

@end

@implementation XEFormSpecialCellSetting


-(CGFloat)cellHeight
{
    if (0 == _cellHeight)
    {
        return [XEFormSetting sharedSetting].cellSetting.cellHeight;
    }
    return _cellHeight;
}

-(XEFormPickerType)pickerType
{
    if (nil == _pickerTypeNum)
    {
        return [XEFormSetting sharedSetting].cellSetting.pickerType;
    }
    return (XEFormPickerType)_pickerTypeNum.integerValue;
}

-(void)setPickerType:(XEFormPickerType)pickerType
{
    _pickerTypeNum = [NSNumber numberWithInteger:pickerType];
}

-(UITableViewCellStyle)cellStyle
{
    if(nil == _cellStyleNum)
    {
        return [XEFormSetting sharedSetting].cellSetting.cellStyle;
    }
    return (UITableViewCellStyle)_cellStyleNum.integerValue;
}

-(void)setCellStyle:(UITableViewCellStyle)cellStyle
{
    _cellStyleNum = [NSNumber numberWithInteger:cellStyle];
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
static CGFloat kDefault_cellHeight =                44.;

static CGFloat kDefault_headerFooterTitleFont =     13.;
static CGFloat kDefault_cellTitleFont =             15.;
static CGFloat kDefault_cellDescriptionFont =       13.;
static CGFloat kDefault_cellTextFiledFont =         15.;
static CGFloat kDefault_cellTextViewFont =          15.;

@interface XEFormSetting ()

@property (nonatomic, strong, readwrite) NSSet *objectProperties;

@end

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
    
    
    cellSetting.cellHeight = kDefault_cellHeight;
    cellSetting.cellStyle = UITableViewCellStyleDefault;
    
    self.headerFooterViewSetting = headerFooterViewSetting;
    self.cellSetting = cellSetting;
    self.cellClassesForRowTypes = self.defaultCellClassesForRowTypes;
    self.cellClassesForRowClasses = self.defaultCellClassesForRowClasses;
    self.viewControllerClassesForRowTypes = self.defaultViewControllerClassesForRowTypes;
    self.viewControllerClassesForRowClasses = self.defaultViewControllerClassesForRowClasses;
}

#pragma mark - Private method

- (NSMutableDictionary *)defaultCellClassesForRowTypes
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            NSClassFromString(@"XEFormDefaultCell"), XEFormRowTypeDefault,
            NSClassFromString(@"XEFormTextFieldCell"), XEFormRowTypeText,
            NSClassFromString(@"XEFormTextViewCell"), XEFormRowTypeLongText,
            NSClassFromString(@"XEFormTextFieldCell"), XEFormRowTypeURL,
            NSClassFromString(@"XEFormTextFieldCell"), XEFormRowTypeEmail,
            NSClassFromString(@"XEFormTextFieldCell"), XEFormRowTypePhone,
            NSClassFromString(@"XEFormTextFieldCell"), XEFormRowTypePassword,
            NSClassFromString(@"XEFormTextFieldCell"), XEFormRowTypeNumber,
            NSClassFromString(@"XEFormTextFieldCell"), XEFormRowTypeFloat,
            NSClassFromString(@"XEFormTextFieldCell"), XEFormRowTypeInteger,
            NSClassFromString(@"XEFormTextFieldCell"), XEFormRowTypeUnsigned,
            NSClassFromString(@"XEFormSwitchCell"), XEFormRowTypeBoolean,
            NSClassFromString(@"XEFormDatePickerCell"), XEFormRowTypeDate,
            NSClassFromString(@"XEFormDatePickerCell"), XEFormRowTypeTime,
            
            nil];
}

- (NSMutableDictionary *)defaultCellClassesForRowClasses
{
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)defaultViewControllerClassesForRowTypes
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            
            NSClassFromString(@"XEFormViewController"), XEFormRowTypeDefault,
            
            nil];
}

- (NSMutableDictionary *)defaultViewControllerClassesForRowClasses
{
    return [NSMutableDictionary dictionary];
}

#pragma mark - Getter & setter

-(void)setBaseViewControllerClass:(Class)baseViewControllerClass
{
    _baseViewControllerClass = baseViewControllerClass;
    if(_baseViewControllerClass)
    {
        // Hack to set super class
        class_setSuperclass(NSClassFromString(@"XEFormViewController"), _baseViewControllerClass);
    }
}

-(Class<XEFormLabelDelegate>)xeFormLabelClass
{
    if ([_delegagte respondsToSelector:@selector(xeFormLabelClass)])
    {
        return [_delegagte xeFormLabelClass];
    }
    return [UILabel class];
}

-(NSSet *)objectProperties
{
    if(nil == _objectProperties)
    {
        NSMutableSet *tempNSObjectProperties = [NSMutableSet setWithArray:@[@"description", @"debugDescription", @"hash", @"superclass"]];
        unsigned int propertyCount;
        objc_property_t *propertyList = class_copyPropertyList([NSObject class], &propertyCount);
        for(unsigned int i = 0; i< propertyCount; i++)
        {
            objc_property_t property = propertyList[i];
            const char *propertyName = property_getName(property);
            [tempNSObjectProperties addObject:@(propertyName)];
        }
        free(propertyList);
        _objectProperties = [tempNSObjectProperties copy];
    }
    return _objectProperties;
}

@end
