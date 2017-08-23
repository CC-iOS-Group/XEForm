//
//  XEFormDynamicViewController.h
//  Pods
//
//  Created by 丁明 on 2017/7/31.
//
//

#import <Foundation/Foundation.h>

#import "XEFormConst.h"
#import "XEFormLabelDelegate.h"

@interface XEFormHeaderFooterViewSetting : NSObject

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@property (nonatomic, strong) NSDictionary<NSString *, id> *titleAttributes;

@end

@interface XEFormSpecialCellSetting : NSObject

/** Title Label */
@property (nonatomic, strong) NSDictionary<NSString *, id> *titleAttributes;

/** Description Label*/
@property (nonatomic, strong) NSDictionary<NSString *, id> *descriptionAttributes;

/** textView attributes*/
@property (nonatomic, strong) NSDictionary<NSString *, id> *textFieldAttributes;

/** textView attributes*/
@property (nonatomic, strong) NSDictionary<NSString *, id> *textViewAttributes;

@property (nonatomic, assign) CGFloat cellHeight;


- (XEFormPickerType)pickerType;
- (void)setPickerType:(XEFormPickerType)pickerType;

- (UITableViewCellStyle)cellStyle;
- (void)setCellStyle:(UITableViewCellStyle)cellStyle;

@end

@interface XEFormCommonCellSetting : XEFormSpecialCellSetting

@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGFloat offsetY;

//** Separator*/
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, assign) CGFloat separatorHeight;

/** Default rowAccessoryView*/
@property (nonatomic, strong) UIImage *indicatorImage;
@property (nonatomic, strong) UIImage *checkMarkImage;
@property (nonatomic, strong) UIColor *indicatorViewTintColor;

@property (nonatomic, strong) UIImage *logoPlaceholder;

@end

@protocol XEFormDelegate <NSObject>

- (void)setImageView:(UIImageView *)imageView withURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder;

@optional

- (Class<XEFormLabelDelegate>)xeFormLabelClass;

@end

@interface XEFormSetting : NSObject

+ (instancetype)sharedSetting;

/** Data setting*/
@property (nonatomic, strong, readonly) NSSet *objectProperties;
/** UI setting*/
@property (nonatomic, strong) Class baseViewControllerClass;

@property (nonatomic, strong) XEFormHeaderFooterViewSetting *headerFooterViewSetting;

@property (nonatomic, strong) XEFormCommonCellSetting *cellSetting;

/** Customize Class*/
@property (nonatomic, strong) NSMutableDictionary *cellClassesForRowTypes;
@property (nonatomic, strong) NSMutableDictionary *cellClassesForRowClasses;
@property (nonatomic, strong) NSMutableDictionary *viewControllerClassesForRowTypes;
@property (nonatomic, strong) NSMutableDictionary *viewControllerClassesForRowClasses;

@property (nonatomic, weak) id<XEFormDelegate> delegagte;

- (Class<XEFormLabelDelegate>)xeFormLabelClass;

@end
