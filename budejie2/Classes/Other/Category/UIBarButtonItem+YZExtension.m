//
//  UIBarButtonItem+YZExtension.m
//  百思不得姐
//
//  Created by Yue on 8/5/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "UIBarButtonItem+YZExtension.h"

@implementation UIBarButtonItem (YZExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    btn.size = btn.currentBackgroundImage.size; //背景图尺寸＝按钮尺寸
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:btn];
}

@end
