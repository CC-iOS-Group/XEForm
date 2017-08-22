//
//  XEOptionsForm.m
//  Pods
//
//  Created by 丁明 on 2017/6/28.
//
//

#import "XEOptionsForm.h"

#import "XEFormController.h"
#import "XEFormConst.h"
#import "NSObject+Utils.h"
#import "XEFormRowObject.h"

@implementation XEOptionsForm

-(instancetype)initWithRow:(XEFormRowObject *)row
{
    self = [super init];
    if (self)
    {
        self.row = row;
        id action = ^(__unused id sender)
        {
            if (row.action)
            {
                // Pass the expected cell as the sender
                XEFormController *formController = row.form.formController;
                [self enumerateRowsWithBlock:^(XEFormRowObject *aRow, NSIndexPath *indexPath) {
                    if([aRow.key isEqualToString:row.key])
                    {
                        row.action([formController.formTableView cellForRowAtIndexPath:indexPath], ^{
                            
                        }, ^(NSError *error) {
                            
                        });
                    }
                }];
            }
        };
        
        NSMutableArray *rows = [NSMutableArray array];
        if(row.placeholder)
        {
            XEFormRowObject *placeholderRow = [[XEFormRowObject alloc] initWithKey:@"0" Class:nil type:XEFormRowTypeOption];
            placeholderRow.action = action;
            placeholderRow.valueTransformer = row.valueTransformer;
            placeholderRow.title = [row rowDescription];
            [rows addObject:placeholderRow];
        }
        for (NSUInteger i = 0; i < row.options.count; i++)
        {
            NSInteger index = i + (row.placeholder ? 1 : 0);
            XEFormRowObject *placeholderRow = [[XEFormRowObject alloc] initWithKey:[@(index) description] Class:[NSString class] type:XEFormRowTypeOption];
            placeholderRow.action = action;
            placeholderRow.valueTransformer = row.valueTransformer;
            placeholderRow.title = [row optionDescriptionAtIndex:index];
            [rows addObject:placeholderRow];
        }
        
        self.rows = rows;
    }
    return self;
}

- (id)valueForKey:(NSString *)key
{
    NSInteger index = [key integerValue];
    return @([self.row isOptionSelectedAtIndex:index]);
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    NSUInteger index = [key integerValue];
    [self.row setOptionSelected:[value boolValue] atIndex:index];
}

@end
