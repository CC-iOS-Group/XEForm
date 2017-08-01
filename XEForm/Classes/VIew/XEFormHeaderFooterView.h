//
//  XEFormHeaderFooterView.h
//  Pods
//
//  Created by 丁明 on 2017/7/28.
//
//

#import <UIKit/UIKit.h>

@interface XEFormHeaderFooterView : UIView

@property (nonatomic, copy) NSAttributedString *text;

@property (nonatomic, assign, readonly) CGSize viewSize;

-(instancetype)initWithTableWidth:(CGFloat)tableWidth text:(NSAttributedString *)text;

+(CGFloat)heightWithMaxWidth:(CGFloat)maxWidth Text:(NSAttributedString *)text;

@end
