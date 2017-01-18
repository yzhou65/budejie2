//
//  AppDelegate.m
//  百思不得姐
//
//  Created by Yue on 8/3/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "AppDelegate.h"
#import "YZTabBarController.h"
#import "YZPushGuideView.h"
#import "YZTopWindow.h"

@interface AppDelegate () //<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    //设置窗口根控制器
//    YZTabBarController *tabBarController = [[YZTabBarController alloc] init];
//    tabBarController.delegate = self;
    self.window.rootViewController = [[YZTabBarController alloc] init];
    
    
    //显示窗口
    [self.window makeKeyAndVisible];
    
    //显示推送引导
    [YZPushGuideView show];
    
    return YES;
}

#pragma mark - <UITabBarControllerDelegate>
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    //发出一个通知
//    [YZNoteCenter postNotificationName:YZTabBarDidSelectNotification object:nil userInfo:nil];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //添加一个window。点击此window可以让屏幕上的scrollView回滚到最顶部
    [YZTopWindow show];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
