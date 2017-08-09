//
//  XEFormDefaultCell.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import "XEFormBaseCell.h"

@interface XEFormDefaultCell : XEFormBaseCell

@property (nonatomic, strong) UIImageView *rowLogoView;
@property (nonatomic, strong) UIView *rowContentView;
@property (nonatomic, assign) UITableViewCellAccessoryType    rowAccessoryType;
@property (nonatomic, strong) UIView *rowAccessoryView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end
