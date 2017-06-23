//
//  XEFormRowCellDelegate.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

@class XEFormRow;

@protocol XEFormRowCellDelegate <NSObject>

@property (nonatomic, strong) XEFormRow *row;

@optional

+ (CGFloat)heightForRow:(XEFormRow *)row width:(CGFloat)width;
- (void)didSelectWithTableView:(UITableView *)tableView
                    controller:(UIViewController *)controller;

@end
