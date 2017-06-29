//
//  XEFormSectionObject.m
//  Pods
//
//  Created by 丁明 on 2017/6/28.
//
//

#import "XEFormSectionObject.h"

#import "XEFormRowObject.h"
#import "XEOptionsForm.h"
#import "XETemplateForm.h"
#import "XEFormUtils.h"
#import "XEFormController.h"

@implementation XEFormSectionObject

+(NSArray *)sectionsWithForm:(XEForm *)form
{
    NSMutableArray *sections = [NSMutableArray array];
    XEFormSectionObject *section = nil;
    for (XEFormRowObject *row in form.rows)
    {
        XEForm *subform = nil;
        if(row.options && row.isInline)
        {
            subform = [[XEOptionsForm alloc] initWithRow:row];
        }
        else if([row isCollectionType] && row.isInline)
        {
            subform = [[XETemplateForm alloc] initWithRow:row];
        }
        // custom sub XEForm
        else if([row.valueClass isSubclassOfClass:[XEForm class]] && row.isInline)
        {
            if(!row.value && [row respondsToSelector:@selector(init)] &&
               [row.valueClass isSubclassOfClass:XEFormClassFromString(@"NSManagedObject")])
            {
                row.value = [[row.valueClass alloc] init];
            }
            subform = row.value;
        }
        
        if(subform)
        {
            NSArray *subsections = [XEFormSectionObject sectionsWithForm:subform];
            [sections addObjectsFromArray:subsections];
            
            section = [subsections firstObject];
            if(!section.header)
            {
                section.header = row.header ? : row.title;
            }
            section.isSortable = row.isSortable;
            section = nil;
        }
        else
        {
            if(!section || row.header)
            {
                section = [[XEFormSectionObject alloc] init];
                //                section.form = form;
                section.header = row.header;
                section.isSortable = ([form isKindOfClass:[XETemplateForm class]] && ((XETemplateForm *)form).row.isSortable);
                [sections addObject:section];
            }
            [section.rows addObject:row];
            if(row.footer)
            {
                section.footer = row.footer;
                section = nil;
            }
        }
    }
    return sections;
}

- (BOOL)respondsToSelector:(SEL)selector
{
    if ([NSStringFromSelector(selector) hasPrefix:@"set"])
    {
        return YES;
    }
    return [super respondsToSelector:selector];
}

#pragma mark - Getter & setter

-(NSMutableArray<XEFormRowObject *> *)rows
{
    if (nil == _rows)
    {
        _rows = [NSMutableArray array];
    }
    return _rows;
}

@end
