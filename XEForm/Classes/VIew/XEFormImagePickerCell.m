//
//  XEFormImagePickerCell.m
//  Pods
//
//  Created by 丁明 on 2017/7/5.
//
//

#import "XEFormImagePickerCell.h"

#import "XEFormConst.h"
#import "XEFormRowObject.h"
#import "XEFormUtils.h"

@interface XEFormImagePickerCell ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@end

@implementation XEFormImagePickerCell

-(void)setUp
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.accessoryView = self.accessoryImageView;
    [self setNeedsLayout];
}

-(void)dealloc
{
    _imagePickerController.delegate = nil;
}

-(void)layoutSubviews
{
    CGRect frame = self.accessoryImageView.bounds;
    frame.size.height = self.bounds.size.height - 10.;
    UIImage *image = self.accessoryImageView.image;
    frame.size.width = image.size.height ? image.size.width * (frame.size.height/ image.size.height): 0;
    self.accessoryImageView.bounds = frame;
    
    [super layoutSubviews];
}

-(void)update
{
    self.textLabel.text = self.row.title;
    self.textLabel.accessibilityValue = self.textLabel.text;
    self.accessoryImageView.image = [self imageValue];
    [self setNeedsLayout];
}

- (UIImage *)imageValue
{
    if (self.row.value)
    {
        return self.row.value;
    }
    else if (self.row.placeholder)
    {
        UIImage *placeholderImage = self.row.placeholder;
        if ([placeholderImage isKindOfClass:[NSString class]])
        {
            placeholderImage = [UIImage imageNamed:self.row.placeholder];
        }
        return placeholderImage;
    }
    return nil;
}

-(void)didSelectWithTableView:(UITableView *)tableView controller:(UIViewController *)controller
{
    [XEFormsFirstResponder(tableView) resignFirstResponder];
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    
    if (!TARGET_IPHONE_SIMULATOR &&
        ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [controller presentViewController:self.imagePickerController animated:YES completion:nil];
    }
    else if ([UIAlertController class])
    {
        UIAlertControllerStyle style = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? UIAlertControllerStyleAlert: UIAlertControllerStyleActionSheet;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:style];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Take Photo", nil) style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [self actionSheet:nil didDismissWithButtonIndex:0];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Photo Library", nil) style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [self actionSheet:nil didDismissWithButtonIndex:1];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:NULL]];
        
        self.controller = controller;
        [controller presentViewController:alert animated:YES completion:NULL];
    }
    else
    {
        self.controller = controller;
        [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Take Photo", nil), NSLocalizedString(@"Photo Library", nil), nil] showInView:controller.view];
    }
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.row.value = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
//    if (self.row.action)
//    {
//        self.row.action(self);
//    }
    [self update];
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    switch (buttonIndex)
    {
        case 0:
        {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        }
        case 1:
        {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        }
        default:
        {
            self.controller = nil;
            return;
        }
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        self.imagePickerController.sourceType = sourceType;
        [self.controller presentViewController:self.imagePickerController animated:YES completion:nil];
    }
    self.controller = nil;
}

#pragma mark - Getter & setter

-(UIImagePickerController *)imagePickerController
{
    if (nil == _imagePickerController)
    {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}

-(UIImageView *)accessoryImageView
{
    if (nil == _accessoryImageView)
    {
        _accessoryImageView = [[UIImageView alloc] init];
        _accessoryImageView.contentMode = UIViewContentModeScaleAspectFill;
        _accessoryImageView.clipsToBounds = YES;
    }
    return _accessoryImageView;
}

@end
