//
//  XEFormObject.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

@class XEFormRowObject, XEFormController;

@protocol XEFormDelegate <NSObject>


/**
 The dataSource of a form, you can set and get as you want
 */
@property (nonatomic, strong) NSArray<XEFormRowObject *> *rows;

@property (nonatomic, strong) XEFormController *formController;

@optional

@property (nonatomic, strong) XEFormRowObject *row;

/**
 Only used to Ignore the property you don't want to count in,
 won't influence the 'rows' property and what declared in 'rows'

 @return The property key you don't want to count in
 */
- (NSSet<NSString *> *)excludeProperties;


@end
