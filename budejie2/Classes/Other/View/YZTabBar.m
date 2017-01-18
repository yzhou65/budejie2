//
//  YZTabBar.m
//  百思不得姐
//
//  Created by Yue on 8/5/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZTabBar.h"
#import "YZPostWordViewController.h"
#import "YZNavigationController.h"
#import "YZPublishViewController.h"

@interface YZTabBar ()
/** 发布按钮 */
@property(nonatomic, weak) UIButton *publishBtn;

@end

@implementation YZTabBar

/**
 此处只需要初始化发布按钮。在此处不应该设置子控件尺寸，而应该在layoutSubviews中设置
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //设置tabbar的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        
        //“发布”按钮
        UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        publishBtn.size = publishBtn.currentBackgroundImage.size;
        
        //”发布“按钮监听
        [publishBtn addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:publishBtn];
        self.publishBtn = publishBtn;
    }
    return self;
}

UIWindow *window;

- (void)publishClick
{
    //窗口级别：
    //UIWindowLevelNormal < UIWindowLevelStatusBar < UIWindowLevelAlert
//    window = [[UIWindow alloc] init];
//    window.frame = [UIScreen mainScreen].bounds;
////    window.frame = CGRectMake(100, 100, 200, 200);
//    window.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
//    window.hidden = NO; //window不需要被加到任何控件上，可以直接显示
    
//    [YZPublishView show];
    
    YZPublishViewController *publishVC = [[YZPublishViewController alloc] init];
    
    //这里不能使用self来弹出其他控制器，因为self之行了dismiss操作
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root presentViewController:publishVC animated:NO completion:nil];
}


/**
 布局其子控件
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //标记按钮是否已经添加过监听
    static BOOL isTargetAdded = NO;
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
//    self.publishBtn.size = self.publishBtn.currentBackgroundImage.size;
    self.publishBtn.center = CGPointMake(width * 0.5, height * 0.5);
    
    //设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    for (UIControl *button in self.subviews) {
        if (![button isKindOfClass:[UIControl class]] || button == self.publishBtn) {
            continue;
        }
        
        //计算按钮的x值，并增加索引
        CGFloat buttonX = buttonW * (index > 1 ? ++index : index++);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        //监听按钮点击. layoutSubviews可能会被调用多次，所以为了保证按钮的监听只添加一次，所以要进行判断
        if (!isTargetAdded) {
            [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    isTargetAdded = YES;
}

- (void)buttonClick
{
    //发通知
    [YZNoteCenter postNotificationName:YZTabBarDidSelectNotification object:nil userInfo:nil];
}

@end
