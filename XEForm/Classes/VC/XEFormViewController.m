//
//  XEFormViewController.m
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import "XEFormViewController.h"

#import "XEFormController.h"
#import "XEForm.h"
#import "XEFormRowObject.h"
#import "XEOptionsForm.h"
#import "XETemplateForm.h"
#import "XEFormUtils.h"

@interface XEFormViewController ()

@property (nonatomic, strong, readwrite) XEFormController *formController;

@end

@implementation XEFormViewController

@synthesize row = _row;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(nil == self.tableView)
    {
        UITableView *formTableView =
        [[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                     style:UITableViewStyleGrouped];
        if ([formTableView respondsToSelector:@selector(cellLayoutMarginsFollowReadableWidth)])
        {
            formTableView.cellLayoutMarginsFollowReadableWidth = NO;
        }
        self.formController.formTableView = formTableView;
    }
    if (nil == self.tableView.superview)
    {
        self.view = self.tableView;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    
    if(selected)
    {
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:selected animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self.tableView deselectRowAtIndexPath:selected animated:YES];
    }
}

-(void)dealloc
{
    self.formController.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)tableView
{
    return self.formController.formTableView;
}

#pragma mark  - XEFormControllerDelegate

-(void)didSetFormTableView:(UITableView *)formTableView
{
    if(![self isViewLoaded])
    {
        self.view = formTableView;
    }
}

#pragma mark - Getter & setter

-(void)setRow:(XEFormRowObject *)row
{
    _row = row;
    
    XEForm *form = nil;
    if (row.options)
    {
        form = [[XEOptionsForm alloc] initWithRow:row];
    }
    else if ([row isCollectionType])
    {
        form = [[XETemplateForm alloc] initWithRow:row];
    }
    else if([row.valueClass isSubclassOfClass:[XEForm class]])
    {
        if (!row.value && ![row.valueClass isSubclassOfClass:XEFormClassFromString(@"NSManagedObject")])
        {
            row.value = [[row.valueClass alloc] init];
        }
        form = row.value;
    }
    else
    {
        [NSException raise:XEFormsException format:@"XEFormViewController field value must be subclass of XEForm"];
    }
    
    self.formController.parentFormController = row.form.formController;
    self.formController.form = form;
}

-(XEFormController *)formController
{
    if (nil == _formController)
    {
        _formController = [[XEFormController alloc] init];
        _formController.delegate = self;
    }
    return _formController;
}

@end
