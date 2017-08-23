//
//  XEFormDefaultCell.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import "XEFormBaseCell.h"
#import "XEFormLabelDelegate.h"

@interface XEFormDefaultCell : XEFormBaseCell

@property (nonatomic, strong) UIImageView *rowLogoView;
@property (nonatomic, strong) UIView *rowContentView;
@property (nonatomic, assign) UITableViewCellAccessoryType    rowAccessoryType;
@property (nonatomic, strong) UIView *rowAccessoryView;
@property (nonatomic, strong) UIView<XEFormLabelDelegate> *titleLabel;
@property (nonatomic, strong) UIView<XEFormLabelDelegate> *descriptionLabel;

@end
