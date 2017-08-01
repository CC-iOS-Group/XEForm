//
//  XEFormDefaultCell.m
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import "XEFormDefaultCell.h"

#import "XEFormRowObject.h"
#import "XEFormConst.h"
#import "XEFormUtils.h"
#import "XEFormRowViewControllerDelegate.h"
#import "XEFormViewController.h"

@implementation XEFormDefaultCell

-(void)update
{
    self.textLabel.text = self.row.title;
    self.textLabel.accessibilityValue = self.textLabel.text;
    self.detailTextLabel.text = [self.row rowDescription];
    self.detailTextLabel.accessibilityValue = self.detailTextLabel.text;
    
    if ([self.row.type isEqualToString:XEFormRowTypeLabel])
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        if (nil == self.row.action)
        {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    else if([self.row isSubform] || self.row.segue)
    {
        // TODO: custom Indicator
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if([self.row.type isEqualToString:XEFormRowTypeBoolean] ||
            [self.row.type isEqualToString:XEFormRowTypeOption])
    {
        self.detailTextLabel.text = nil;
        self.detailTextLabel.accessibilityValue = self.detailTextLabel.text;
        self.accessoryType = [self.row.value boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    else if([self.row.type isEqualToString:XEFormRowTypeText])
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(self.row.action)
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

-(void)didSelectWithTableView:(UITableView *)tableView controller:(UIViewController *)controller
{
    if([self.row.type isEqualToString:XEFormRowTypeBoolean] ||
       [self.row.type isEqualToString:XEFormRowTypeOption])
    {
        [XEFormsFirstResponder(tableView) resignFirstResponder];
        self.row.value = @(![self.row.value boolValue]);
        if (self.row.action)
        {
            self.row.action(self);
        }
        self.accessoryType = [self.row.value boolValue] ? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
        if ([self.row.type isEqualToString:XEFormRowTypeOption])
        {
            NSIndexPath *indexPath = [tableView indexPathForCell:self];
            if (indexPath)
            {
                // Reload section, in case fields are linked
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
        else
        {
            // Deselect the cell
            [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
        }
    }
    else if (self.row.action && (![self.row isSubform] || !self.row.options))
    {
        [XEFormsFirstResponder(tableView) resignFirstResponder];
        self.row.action(self);
        [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    }
    else if(self.row.segue && [self.row.segue class] != self.row.segue)
    {
        [XEFormsFirstResponder(tableView) resignFirstResponder];
        if ([self.row.segue isKindOfClass:[UIStoryboardSegue class]])
        {
            [controller prepareForSegue:self.row.segue sender:self];
            [(UIStoryboardSegue *)self.row.segue perform];
        }
        else if ([self.row.segue isKindOfClass:[NSString class]])
        {
            [controller performSegueWithIdentifier:self.row.segue sender:self];
        }
    }
    else if ([self.row isSubform])
    {
        [XEFormsFirstResponder(tableView) resignFirstResponder];
        UIViewController *subcontroller = nil;
        if ([self.row.valueClass isSubclassOfClass:[UIViewController class]])
        {
            subcontroller = self.row.value ? : [[self.row.valueClass class] init];
        }
        else if(self.row.viewController && self.row.viewController == [self.row.viewController class])
        {
            subcontroller = [[self.row.viewController alloc] init];
            ((id <XEFormRowViewControllerDelegate>)subcontroller).row = self.row;
        }
        else if ([self.row.viewController isKindOfClass:[UIViewController class]])
        {
            subcontroller = self.row.viewController;
            ((id <XEFormRowViewControllerDelegate>)subcontroller).row = self.row;
        }
        else
        {
            if(self.row.viewController)
            {
                subcontroller = self.row.viewController;
            }
            else
            {
                Class subViewControllerClass = self.row.subViewControllerClass;
                if (subViewControllerClass)
                {
                    subcontroller = [[[self.row subViewControllerClass] alloc] init];
                }
                else
                {
                    return;
                }
            }
            ((id <XEFormRowViewControllerDelegate>)subcontroller).row = self.row;
        }
        if (!subcontroller.title)
        {
            subcontroller.title = self.row.title;
        }
        if (self.row.segue)
        {
            UIStoryboardSegue *segue = [[self.row.segue alloc] initWithIdentifier:self.row.key source:controller destination:subcontroller];
            [controller prepareForSegue:self.row.segue sender:self];
            [segue perform];
        }
        else
        {
            NSAssert(controller.navigationController != nil, @"Attempted to push a sub-viewController from a form that is not embedded inside a UINavigationController. That won't work!");
            [controller.navigationController pushViewController:subcontroller animated:YES];
        }
    }
}

@end
