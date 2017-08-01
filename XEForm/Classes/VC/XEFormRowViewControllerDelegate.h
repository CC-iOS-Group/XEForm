//
//  XEFormRowViewController.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

@class XEFormRowObject, XEFormController;

@protocol XEFormRowViewControllerDelegate <NSObject>

@property (nonatomic, strong) XEFormRowObject *row;

@property (nonatomic, strong, readonly) XEFormController *formController;

- (UITableView *)tableView;

@end
