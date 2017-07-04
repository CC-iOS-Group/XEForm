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

- (void)setUp;
- (void)update;
- (void)didSelectWithTableView:(UITableView *)tableView
                    controller:(UIViewController *)controller;
- (UITableView *)tableView;

@end
