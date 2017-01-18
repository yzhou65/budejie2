//
//  YZLoginRegisterViewController.m
//  budejie
//
//  Created by Yue on 8/7/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZLoginRegisterViewController.h"

@interface YZLoginRegisterViewController ()
/** 登录框距离控制器view左边的间距约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;

@end

@implementation YZLoginRegisterViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    //先在info.plist中加入View controller-based status bar appearance
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (IBAction)back
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 在xib中设置了“注册账号”按钮的selected文字为“已有账号？”。那么就只需要设置按钮的selected状态，不用再使用代码改文字。
 */
- (IBAction)showLoginOrRegister:(UIButton *)sender
{
    //退出键盘
    [self.view endEditing:YES];
    
    if (self.loginViewLeftMargin.constant == 0) { //显示注册界面
        self.loginViewLeftMargin.constant -= self.view.width;
        sender.selected = YES;
//        [sender setTitle:@"已有账号?" forState:UIControlStateNormal];
    }
    else {
        self.loginViewLeftMargin.constant = 0;
        sender.selected = NO;
//        [sender setTitle:@"注册账号" forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

/**
 让当前控制器对应的状态栏是白色
 */
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
