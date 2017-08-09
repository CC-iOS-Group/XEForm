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

@property (nonatomic, strong) UIView *upSeparatorView;
@property (nonatomic, strong) UIView *downSeparatorView;
@property (nonatomic, assign) UITableViewCellStyle style;

@property (nonatomic, weak, readonly) UITableViewCell<XEFormRowCellDelegate> *nextCell;

- (void)setUp;
- (void)update;
- (UITableView *)tableView;

@end
