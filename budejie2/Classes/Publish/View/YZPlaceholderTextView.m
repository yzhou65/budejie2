//
//  YZPlaceholderTextView.m
//  01-百思不得姐
//
//  Created by xiaomage on 15/8/5.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "YZPlaceholderTextView.h"

@interface YZPlaceholderTextView ()
/** 占位文字label */
@property(nonatomic, weak) UILabel *placeholderLabel;
@end

@implementation YZPlaceholderTextView
- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        //添加一个用来显示占位文字的label
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0; //能自动换行
        placeholderLabel.x = 4;
        placeholderLabel.y = 7;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 垂直方向上永远有弹簧效果
        self.alwaysBounceVertical = YES;
        
        // 默认字体
        self.font = [UIFont systemFontOfSize:15];
        
        // 默认的占位文字颜色
        self.placeholderColor = [UIColor grayColor];
        
        // 监听文字改变
        [YZNoteCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [YZNoteCenter removeObserver:self];
}

/**
 * 监听文字改变. 每次文字发生改变都要调用
 */
- (void)textDidChange
{
    self.placeholderLabel.hidden = self.hasText;
}

/**
 更新占位文字的尺寸
 */
- (void)layoutSubviews
{
//    CGSize size = CGSizeMake(YZScreenW - 2 * self.placeholderLabel.x, MAXFLOAT);
//    self.placeholderLabel.size = [self.placeholder boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
    
    [super layoutSubviews];
    self.placeholderLabel.width = self.frame.size.width - 2 * self.placeholderLabel.x;
    [self.placeholderLabel sizeToFit];
}

#pragma mark - 重写setter
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    
    [self setNeedsLayout];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
    
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}

/**
 setNeedsDisplay: 会在恰当的时候自动调用drawRect
 setNeedsLayout：会在恰当的时候自动调用layoutSubviews
 */

@end
