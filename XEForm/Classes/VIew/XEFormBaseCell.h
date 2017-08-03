//
//  XEFormBaseCell.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import <UIKit/UIKit.h>

#import "XEFormRowCellDelegate.h"

@interface XEFormBaseCell : UITableViewCell<XEFormRowCellDelegate>

@property (nonatomic, weak, readonly) UITableViewCell<XEFormRowCellDelegate> *nextCell;

@property (nonatomic, strong) UIImageView *rowLogoView;
@property (nonatomic, strong) UIView *rowContentView;
@property (nonatomic, strong) UIView *upSeparatorView;
@property (nonatomic, strong) UIView *downSeparatorView;
@property (nonatomic, assign) UITableViewCellAccessoryType    rowAccessoryType;
@property (nonatomic, strong) UIView *rowAccessoryView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

- (void)setUp;
- (void)update;
- (void)didSelectWithTableView:(UITableView *)tableView
                    controller:(UIViewController *)controller;
- (UITableView *)tableView;

@end
