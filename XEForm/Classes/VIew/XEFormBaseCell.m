//
//  XEFormBaseCell.m
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

#import "XEFormBaseCell.h"
#import "XEFormRowObject.h"

@implementation XEFormBaseCell

@synthesize row = _row;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRow:(XEFormRowObject *)row
{
    _row = row;
    //configure cell after setting field as well
    if(_row.cellConfig)
    {
        [_row.cellConfig removeObjectForKey:@"style"];
        [_row.cellConfig enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self setValue:obj forKey:key];
        }];
    }
    
//    if([self respondsToSelector:@selector(configWithValue:)])
//    {
//        [self configWithValue:row.value];
//    }
}

@end
