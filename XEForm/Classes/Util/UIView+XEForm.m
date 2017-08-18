//
//  UIView+XEForm.m
//  Pods
//
//  Created by 丁明 on 2017/8/16.
//
//

#import "UIView+XEForm.h"

#import "XEFormBaseCell.h"

@implementation UIView(XEForm)

- (XEFormBaseCell *)formCell
{
    if ([self isKindOfClass:[XEFormBaseCell class]]) {
        return (XEFormBaseCell *)self;
    }
    if (self.superview) {
        XEFormBaseCell * tableViewCell = [self.superview formCell];
        if (tableViewCell != nil) {
            return tableViewCell;
        }
    }
    return nil;
}

- (UIView *)findFirstResponder
{
    if ([self isFirstResponder])
    {
        return self;
    }
    for (UIView *subview in self.subviews)
    {
        UIView *responder = [subview findFirstResponder];
        if (responder)
        {
            return responder;
        }
    }
    return nil;
}


@end
