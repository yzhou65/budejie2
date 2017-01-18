//
//  YZFriendTrendsViewController.m
//  百思不得姐
//
//  Created by Yue on 8/3/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZFriendTrendsViewController.h"
#import "YZRecommendViewController.h"
#import "YZLoginRegisterViewController.h"

@interface YZFriendTrendsViewController ()

@end

@implementation YZFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏标题
//    self.title = @"我的关注"; //这样会导致tabBar的标题和导航栏标题都改了.相当于将navigationItem.title和tabBarItem.title都改成了“我的关注”
    
    self.navigationItem.title = @"我的关注";
    
    //设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsClick)];
    
    self.view.backgroundColor = YZGlobalBg;
    
    
}

- (void)friendsClick
{
    YZRecommendViewController *vc = [[YZRecommendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginRegister
{
    YZLoginRegisterViewController *login = [[YZLoginRegisterViewController alloc] init];
    [self presentViewController:login animated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
