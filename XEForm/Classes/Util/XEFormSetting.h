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

@end

@interface XEFormSetting : NSObject

+ (instancetype)sharedSetting;

@property (nonatomic, strong) Class BaseViewController;

@property (nonatomic, strong) XEFormHeaderFooterViewSetting *headerFooterViewSetting;

@end
