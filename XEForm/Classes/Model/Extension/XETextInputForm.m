//
//  XETextInputForm.m
//  Pods
//
//  Created by 丁明 on 2017/8/4.
//
//

#import "XETextInputForm.h"

#import "XEFormRowObject.h"
#import "XEFormConst.h"

@interface XETextInputForm ()
{
    NSString *_type;
}
@end

@implementation XETextInputForm

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}


- (void)textRow:(XEFormRowObject *)textRow
{
    textRow.value = self.text;
    textRow.title = nil;
    self.type ? textRow.type = self.type : nil;
}

-(XEFormRowObject *)textRow
{
    return [self rowObjectForKey:@"text"];
}

-(NSString *)type
{
    return _type;
}


-(void)setType:(NSString *)type
{
    _type = type;
}

@end
