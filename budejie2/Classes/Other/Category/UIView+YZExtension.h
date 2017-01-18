//
//  UIView+YZExtension.h
//  百思不得姐
//
//  Created by Yue on 8/5/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YZExtension)

@property(assign, nonatomic) CGSize size;
@property(assign, nonatomic) CGFloat width;
@property(assign, nonatomic) CGFloat height;
@property(assign, nonatomic) CGFloat x;
@property(assign, nonatomic) CGFloat y;
@property(assign, nonatomic) CGFloat centerX;
@property(assign, nonatomic) CGFloat centerY;

/**
 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;

//- (CGFloat)x;
//- (CGFloat)y;

//在分类中声明@property，只会生成方法的声明，不会生成方法的实现和带有_下划线的成员变量。

+ (instancetype)viewFromXib;

@end
