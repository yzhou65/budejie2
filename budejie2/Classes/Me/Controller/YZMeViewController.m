//
//  YZMeViewController.m
//  百思不得姐
//
//  Created by Yue on 8/3/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZMeViewController.h"
#import "YZMeCell.h"
#import "YZMeFooterView.h"
#import "YZSettingViewController.h"

@interface YZMeViewController ()

@end

@implementation YZMeViewController
static NSString *YZMeId = @"me";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNav];
    
    [self setupTableView];
}

/**
 设置tableView

 */
- (void)setupTableView
{
    //设置背景色
    self.tableView.backgroundColor = YZGlobalBg;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册cell
    [self.tableView registerClass:[YZMeCell class] forCellReuseIdentifier:YZMeId];
    
    //调整header和footer
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = YZTopicCellMargin;
    
    self.tableView.contentInset = UIEdgeInsetsMake(YZTopicCellMargin - 35, 0, 0, 0);
    
    //设置footerView
    self.tableView.tableFooterView = [[YZMeFooterView alloc] init];
}

/**
 设置导航栏
 */
- (void)setupNav
{
    //设置导航栏标题
    self.navigationItem.title = @"我的";
    
    //设置导航栏右边的2个按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem];
}


- (void)settingClick
{
    [self.navigationController pushViewController:[[YZSettingViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
}
    
- (void)moonClick
{
    YZLogFunc;
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZMeCell *cell = [tableView dequeueReusableCellWithIdentifier:YZMeId];
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mine_icon_nearby"];
        cell.textLabel.text = @"登录／注册";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"离线下载";
    }
    
    return cell;
}

@end
