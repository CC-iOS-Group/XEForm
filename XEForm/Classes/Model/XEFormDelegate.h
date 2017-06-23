//
//  XEFormObject.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

@class XEFormObject;

@protocol XEFormDelegate <NSObject>


/**
 The dataSource of a form, you can set and get as you want
 */
@property (nonatomic, strong) NSArray<XEFormObject *> *rows;

@optional


/**
 Only used to Ignore the property you don't want to count in,
 won't influence the 'rows' property and what declared in 'rows'

 @return The property key you don't want to count in
 */
- (NSArray<NSString *> *)excludeRows;


/**
 For property 'XXX', you can implements selector 'XXXrow' to set the
 details of this row
 
 @return The XEFormObject you want to display for property through key
 */

@end
