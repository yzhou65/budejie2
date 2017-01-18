//
//  YZTopWindow.m
//  budejie2
//
//  Created by Yue on 8/13/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZTopWindow.h"

@implementation YZTopWindow
static UIWindow *window_;

+ (void)initialize
{
    window_ = [[UIWindow alloc] init];
    window_.frame = CGRectMake(0, 0, YZScreenW, 20);
    window_.windowLevel = UIWindowLevelAlert;
    
    window_.rootViewController = [[UIViewController alloc] init];
    window_.backgroundColor = [UIColor clearColor];
    
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowClick)]];
}

+ (void)show
{
    window_.hidden = NO;
}

+ (void)hide
{
    window_.hidden = YES;
}

/**
 addGestureRecognizer中添加的self是个类，所以这个windowClick必须是类方法
 监听窗口的点击
 */
+ (void)windowClick
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}

+ (void)searchScrollViewInView:(UIView *)superview
{
    for (UIScrollView *subview in superview.subviews) {
        //如果是scrollView，滚动到最顶部
        if ([subview isKindOfClass:[UIScrollView class]] && subview.isShowingOnKeyWindow) {
            CGPoint offset = subview.contentOffset;
            offset.y = - subview.contentInset.top;
            [subview setContentOffset:offset animated:YES]; //传入的offset不能是CGPointZero，因为scrollView能回到的最上面应该是一个负数偏移量（在scrollView上面还有标题，如果设为CGPointZero就会盖住标题）
        }
        
        //递归继续查找子控件
        [self searchScrollViewInView:subview];
    }
}
@end
