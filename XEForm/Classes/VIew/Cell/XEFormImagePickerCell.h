//
//  XEFormImagePickerCell.h
//  Pods
//
//  Created by 丁明 on 2017/7/5.
//
//

#import "XEFormBaseCell.h"

@interface XEFormImagePickerCell : XEFormBaseCell

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) UIViewController *controller;

@property (nonatomic, strong) UIImageView *accessoryImageView;

@end
