//
//  UIImage+XEForm.m
//  Pods
//
//  Created by 丁明 on 2017/7/7.
//
//

#import "UIImageView+XEForm.h"

@implementation UIImageView(XEForm)

-(void)setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder
{
    [self setImage:placeholder];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imageURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        [self setImage: image];
    }];
}

@end
