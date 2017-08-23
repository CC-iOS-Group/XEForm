//
//  XELabelDelegate.h
//  Pods
//
//  Created by 丁明 on 2017/8/23.
//
//

#ifndef XELabelDelegate_h
#define XELabelDelegate_h

@class UILabel;

@protocol XEFormLabelDelegate <NSObject>

@property(nullable, nonatomic,copy)   NSString           *text;            // default is nil
@property(null_resettable, nonatomic,strong) UIFont      *font;            // default is nil (system font 17 plain)
@property(null_resettable, nonatomic,strong) UIColor     *textColor;       // default is nil (text draws black)
@property(nullable, nonatomic,strong) UIColor            *shadowColor;     // default is nil (no shadow)
@property(nonatomic)        CGSize             shadowOffset;    // default is CGSizeMake(0, -1) -- a top shadow
@property(nonatomic)        NSTextAlignment    textAlignment;   // default is NSTextAlignmentNatural (before iOS 9, the default was NSTextAlignmentLeft)
@property(nonatomic)        NSLineBreakMode    lineBreakMode;   // default is NSLineBreakByTruncatingTail. used for single and multiple lines of text

// the underlying attributed string drawn by the label, if set, the label ignores the properties above.
@property(nullable, nonatomic,copy)   NSAttributedString *attributedText NS_AVAILABLE_IOS(6_0);  // default is nil

//// the 'highlight' property is used by subclasses for such things as pressed states. it's useful to make it part of the base class as a user property
//
//@property(nullable, nonatomic,strong)               UIColor *highlightedTextColor; // default is nil
//@property(nonatomic,getter=isHighlighted) BOOL     highlighted;          // default is NO

@property(nonatomic,getter=isUserInteractionEnabled) BOOL userInteractionEnabled;  // default is NO
@property(nonatomic,getter=isEnabled)                BOOL enabled;                 // default is YES. changes how the label is drawn

@property(nonatomic) NSInteger numberOfLines;

// these next 3 property allow the label to be autosized to fit a certain width by scaling the font size(s) by a scaling factor >= the minimum scaling factor
// and to specify how the text baseline moves when it needs to shrink the font.

//@property(nonatomic) BOOL adjustsFontSizeToFitWidth;         // default is NO
//@property(nonatomic) UIBaselineAdjustment baselineAdjustment; // default is UIBaselineAdjustmentAlignBaselines

@end

#endif /* XELabelDelegate_h */
