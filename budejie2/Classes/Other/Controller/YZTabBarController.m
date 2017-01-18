//
//  YZTabBarController.m
//  百思不得姐
//
//  Created by Yue on 8/3/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZTabBarController.h"
#import "YZEssenceViewController.h"
#import "YZNewViewController.h"
#import "YZFriendTrendsViewController.h"
#import "YZMeViewController.h"
#import "YZTabBar.h"
#import "YZNavigationController.h"

/**
 [UIColor colorWithRed:(CGFloat) green:(CGFloat) blue:(CGFloat) alpha:(CGFloat)];
 
 * 颜色:
 24bit颜色：RGB
 #ff0000
 #ffff00
 #000000
 #ffffff
 
 32bit颜色：ARGB , A就是alpha
 #ff0000ff
 
 常见颜色：
 #ff0000 red
 #00ff00 green
 #0000ff blue
 #000000 black
 #ffffff white
 
 灰色的特点：RGB一样，如 #111111, #333333, 值的大小决定是深灰还是浅灰
 
 */

@interface YZTabBarController ()

@end

@implementation YZTabBarController

+ (void)initialize
{
    //通过appearance通知设置所有UITabBarItem的文字属性
    //带有UI_APPEARANCE_SELECTOR的方法，都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    //通过appearance通知设置所有UITabBarItem的文字属性
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加子控制器
    [self setupChildVC:[[YZEssenceViewController alloc] init] title:@"Essence" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    [self setupChildVC:[[YZNewViewController alloc] init] title:@"New" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    [self setupChildVC:[[YZFriendTrendsViewController alloc] init] title:@"Friends" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
    [self setupChildVC:[[YZMeViewController alloc] initWithStyle:UITableViewStyleGrouped] title:@"Me" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
    //用自定义的tabBar来替换系统的tabBar，否则中间的加号形发布按钮无法正确添加。
    //tabBar是readonly，所以可以用kvc
//    self.tabBar = [[YZTabBar alloc] init];
    [self setValue:[[YZTabBar alloc] init] forKey:@"tabBar"];
    
}

/**
 initialize child viewControllers
 */
- (void)setupChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    //设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
//    vc.view.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0]; //这句话会导致所有控制器都在一进入app就创建，而不是点击某个tab才创建
    
    //包装一个导航控制器，添加导航控制器为tabBarController的子控制器
    YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:vc];
    
    
    //添加为子控制器
    [self addChildViewController:nav];
    
    //    UIImage *image = [UIImage imageNamed:@"tabBar_essence_click_icon"];
    //    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; //避免系统将图片自动渲染为蓝色. 也可以不通过代码而直接在图片的Render As属性中改为original
}


@end
