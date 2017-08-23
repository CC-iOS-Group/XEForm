//
//  XEFormViewController.m
//  XEForm
//
//  Created by xenobladeX on 06/22/2017.
//  Copyright (c) 2017 xenobladeX. All rights reserved.
//

#import "XEFormDemoViewController.h"

#import <XEForm/XEForm.h>
#import <YYText/YYLabel.h>

#import "SimpleFormViewController.h"

@interface XEFormDemoViewController ()<XEFormDelegate>

@end

@implementation XEFormDemoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"首页";
    [XEFormSetting sharedSetting].delegagte = self;
}

- (IBAction)formButtonClicked:(UIButton *)sender {
    
    SimpleFormViewController *rootViewController = [[SimpleFormViewController alloc] init];
    [self.navigationController pushViewController:rootViewController animated:YES];
}


-(void)setImageView:(UIImageView *)imageView withURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder
{
    [imageView setImage:placeholder];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imageURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        [imageView setImage: image];
    }];
}

-(Class<XEFormLabelDelegate>)xeFormLabelClass
{
    return [YYLabel class];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
