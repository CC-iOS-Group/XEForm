//
//  XEFormSectionObject.m
//  Pods
//
//  Created by 丁明 on 2017/6/28.
//
//

#import "XEFormSectionObject.h"

#import "XEFormRowObject.h"
#import "NSObject+XEForm.h"
#import "XEOptionsForm.h"
#import "XETemplateForm.h"
#import "XEFormUtils.h"
#import "XEFormController.h"

@implementation XEFormSectionObject

+(NSArray *)sectionsWithForm:(id<XEFormDelegate>)form controller:(XEFormController *)formController
{
    form.formController = formController;
    NSMutableArray *sections = [NSMutableArray array];
    XEFormSectionObject *section = nil;
    for (XEFormRowObject *row in form.rows)
    {
        id<XEFormDelegate> subform = nil;
        if(row.options && row.isInline)
        {
            subform = [[XEOptionsForm alloc] initWithRow:row];
        }
        else if([row isCollectionType] && row.isInline)
        {
            subform = [[XETemplateForm alloc] initWithRow:row];
        }
        // custom sub XEForm
        else if([row.valueClass conformsToProtocol:@protocol(XEFormDelegate)] && row.isInline)
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
            NSArray *subsections = [XEFormSectionObject sectionsWithForm:subform controller:formController];
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
                section.form = form;
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

- (void)addNewRowAtIndex:(NSInteger)index
{
    XEFormController *controller = ((XEFormRowObject *)self.rows.lastObject).formController;
    if(controller)
    {
        [(XETemplateForm *)self.form addNewRowAtIndex:index];
        [self.rows setArray:self.form.rows];
    }
}

- (void)removeFieldAtIndex:(NSUInteger)index
{
    XEFormController *controller = ((XEFormRowObject *)self.rows.lastObject).formController;
    if(controller)
    {
        [(XETemplateForm *)self.form removeRowAtIndex:index];
        [self.rows setArray:self.form.rows];
    }
}

- (void)moveFieldAtIndex:(NSUInteger)index1 toIndex:(NSUInteger)index2
{
    XEFormController *controller = ((XEFormRowObject *)self.rows.lastObject).formController;
    if(controller)
    {
        [(XETemplateForm *)self.form moveFieldAtIndex:index1 toIndex:index2];
        [self.rows setArray:self.form.rows];
    }
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

-(NSMutableArray *)rows
{
    if (nil == _rows)
    {
        _rows = [NSMutableArray array];
    }
    return _rows;
}

@end
