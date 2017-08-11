//
//  XEFormRowCellDelegate.h
//  Pods
//
//  Created by 丁明 on 2017/6/22.
//
//

@class XEFormRowObject;

typedef NS_ENUM(NSInteger, XEFormValueChangeSource)
{
    XEFormValueChangeSource_Edit,
    XEFormValueChangeSource_Save,
};

@protocol XEFormRowCellDelegate <NSObject>

@optional

- (void)willChangeRow:(XEFormRowObject *)row newValue:(id)newValue source:(XEFormValueChangeSource)source success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock;

@end
