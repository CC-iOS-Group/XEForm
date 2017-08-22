//
//  XEFormTextViewCell.h
//  Pods
//
//  Created by 丁明 on 2017/7/3.
//
//

#import "XEFormBaseCell.h"

@interface XEFormTextView : UITextView

@end


@interface XEFormTextViewCell : XEFormBaseCell

@property (nonatomic, strong) XEFormTextView *textView;

@end
