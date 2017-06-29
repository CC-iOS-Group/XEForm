//
//  XEFormRowCellDelegate.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

@class XEFormRowObject;

@protocol XEFormRowCellDelegate <NSObject>

@property (nonatomic, strong) XEFormRowObject *row;

@optional

+ (CGFloat)heightForRow:(XEFormRowObject *)row width:(CGFloat)width;

- (void)configWithValue:(id)value;

- (void)didSelectWithTableView:(UITableView *)tableView
                    controller:(UIViewController *)controller;

@end
