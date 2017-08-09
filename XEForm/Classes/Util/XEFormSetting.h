//
//  XEFormDynamicViewController.h
//  Pods
//
//  Created by 丁明 on 2017/7/31.
//
//

#import <Foundation/Foundation.h>

@interface XEFormHeaderFooterViewSetting : NSObject

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@property (nonatomic, strong) NSDictionary<NSString *, id> *titleAttributes;

@end

@interface XEFormSpecialCellSetting : NSObject

//** Title Label */
@property (nonatomic, strong) NSDictionary<NSString *, id> *titleAttributes;


//** Description Label*/
@property (nonatomic, strong) NSDictionary<NSString *, id> *descriptionAttributes;


//** Logo View */
@property (nonatomic, assign)CGSize logoSize;

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

@property (nonatomic, assign) CGFloat cellHeight;

@end

@interface XEFormSetting : NSObject

+ (instancetype)sharedSetting;

@property (nonatomic, strong) Class BaseViewController;

@property (nonatomic, strong) XEFormHeaderFooterViewSetting *headerFooterViewSetting;

@property (nonatomic, strong) XEFormCommonCellSetting *cellSetting;

@end
