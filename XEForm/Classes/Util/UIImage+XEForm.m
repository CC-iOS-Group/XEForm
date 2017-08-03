
//
//  UIImage+XEForm.m
//  Pods
//
//  Created by 丁明 on 2017/8/2.
//
//

#import "UIImage+XEForm.h"

static const CGFloat kLineWidth = 2.;

@implementation UIImage(XEForm)

+ (UIImage *)disclosureIndicatorImageWithIndicatorSize:(CGFloat)indicatorSize
{
    CGFloat width = indicatorSize + 2*kLineWidth;
    
    CGFloat height = indicatorSize*2 + 2*kLineWidth;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(kLineWidth, kLineWidth)];
    [path addLineToPoint:CGPointMake(width - kLineWidth, height/2.)];
    [path addLineToPoint:CGPointMake(kLineWidth, height - kLineWidth)];
    path.lineWidth = kLineWidth;
    [[UIColor blackColor] set];
    [path stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)checkMarkWithCheckMarkSize:(CGSize)checkMarkSize
{
    CGFloat ratio = cos(M_PI/4.);
    CGFloat width = ratio*(checkMarkSize.width + checkMarkSize.height) + 2*kLineWidth;
    CGFloat height = ratio*MAX(checkMarkSize.height, checkMarkSize.width) + 2*kLineWidth;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(kLineWidth, height - ratio*checkMarkSize.height - kLineWidth)];
    [path addLineToPoint:CGPointMake(ratio*checkMarkSize.height + kLineWidth, height - kLineWidth)];
    [path addLineToPoint:CGPointMake(width - kLineWidth, kLineWidth)];
    path.lineWidth = kLineWidth;
    [[UIColor blackColor] set];
    [path stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}



@end
