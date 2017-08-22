//
//  XEFormBaseCell.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import <UIKit/UIKit.h>

#import "XEFormRowCellDelegate.h"
#import "XEFormNavigationAccessoryView.h"

@interface XEFormBaseCell : UITableViewCell

@property (nonatomic, strong) XEFormRowObject *row;

@property (nonatomic, weak) id<XEFormRowCellDelegate> delegate;
@property (nonatomic, strong) UIView *upSeparatorView;
@property (nonatomic, strong) UIView *downSeparatorView;
@property (nonatomic, assign) UITableViewCellStyle style;

- (void)setUp;
- (void)update;
- (XEFormBaseCell *)nextCellWithDirection:(XEFormNavigationDirection)direction;
- (UITableView *)tableView;
- (void)updateRowValueFromOther;


+ (CGFloat)heightForRow:(XEFormRowObject *)row width:(CGFloat)width;
- (void)didSelectWithTableView:(UITableView *)tableView
                    controller:(UIViewController *)controller;

@end
