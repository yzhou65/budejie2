//
//  YZRecommendViewController.m
//  百思不得姐
//
//  Created by Yue on 8/6/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZRecommendViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "YZRecommendCategoryCell.h"
#import "YZRecommendCategory.h"
#import "YZRecommendUserCell.h"
#import "YZRecommendUser.h"

#define YZSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]

@interface YZRecommendViewController () <UITableViewDelegate, UITableViewDataSource>

/** 左边的类别数据 */
@property(nonatomic, strong) NSArray *categories;

/** 右边的用户数据 */
@property(nonatomic, strong) NSArray *users;

/** 左边的类别表格 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

/** 右边的用户表格 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

/** 上一次的请求参数 */
@property(nonatomic, strong) NSMutableDictionary *params;

/** AFN请求管理者 */
@property(nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation YZRecommendViewController

static NSString * const YZCategoryID = @"category";
static NSString * const YZUserID = @"user";

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //控件的初始化
    [self setupTableView];
    
    //添加刷新控件
    [self setupRefresh];
    
    //加载左侧的类别数据
    [self loadCategories];
    
}

/**
 加载左侧的类别数据
 */
- (void)loadCategories
{
    //显示指示器
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    //发送请求给服务器
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    
    [self.manager GET:budejie_url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        //隐藏指示器蒙版
        [SVProgressHUD dismiss];
        
        //服务器返回的JSON数据
        //        YZLog(@"%@", responseObject);
        self.categories = [YZRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //刷新表格
        [self.categoryTableView reloadData];
        
        //默认选中首行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        //让users表格进入下拉刷新状态
        [self.userTableView.mj_header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //隐藏指示器蒙版
        [SVProgressHUD dismiss];
        
        //显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败！"];
    }];

}

/**
 控件的初始化
 */
- (void)setupTableView
{
    //使用了xib来定制cell，所以要对相应的tableView进行cell的注册
    //现在有2个tableView公用一个控制器
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZRecommendCategoryCell class]) bundle:nil] forCellReuseIdentifier:YZCategoryID];
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:YZUserID];
    
    //设置inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categoryTableView.contentInset;
    self.userTableView.rowHeight = 70;
    
    //标题
    self.title = @"推荐关注";
    
    //背景色
    self.view.backgroundColor = YZGlobalBg;
}

/**
 添加刷新控件
 */
- (void)setupRefresh
{
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
}

#pragma mark - 加载用户数据
/**
 在最顶部，下拉刷新加载新用户
 */
- (void)loadNewUsers
{
    YZRecommendCategory *rc = YZSelectedCategory;
    
    //设置当前页码为1
    rc.currentPage = 1;
    
    //发送请求给服务器，加载右侧的数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(rc.ID);
    params[@"page"] = @(rc.currentPage);
    self.params = params;
    
    //发送请求给服务器，加载右侧的数据
    [self.manager GET:budejie_url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        //        YZLog(@"%@", responseObject[@"list"]);
        
        //字典数组转为模型数组
        NSArray *users = [YZRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //清除以前的所有旧数据. 否则每次下拉刷新就会重复添加数据到users里
        [rc.users removeAllObjects];
        
        //添加到当前类别对应的用户数组中
        [rc.users addObjectsFromArray:users];
        
        //保存总数
        rc.total = [responseObject[@"total"] integerValue];
        
        //如果上一次请求和当前请求不一样(即不是最后一次请求)，就不要继续上一次的请求
        if (self.params != params) return;
        
    
        //刷新右边的表格
        [self.userTableView reloadData];
        
        //结束刷新
        [self.userTableView.mj_header endRefreshing];
        
        //让底部控件结束刷新
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //如果上一次请求和当前请求不一样，就不要继续上一次的请求
        if (self.params != params) return;
        
        //提醒错误
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        //结束刷新
        [self.userTableView.mj_header endRefreshing];
    }];
}

/**
 拖到最底部，上拉刷新加载更多用户
 */
- (void)loadMoreUsers
{
//    YZLogFunc;
    
    YZRecommendCategory *category = YZSelectedCategory;
    
    //发送请求给服务器，加载右侧的数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.ID);
    params[@"page"] = @(++category.currentPage);
    [self.manager GET:budejie_url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        //        YZLog(@"%@", responseObject[@"list"]);
        
        //字典数组转为模型数组
        NSArray *users = [YZRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //添加到当前类别对应的用户数组中
        [category.users addObjectsFromArray:users];
        
        //刷新右边的表格
        [self.userTableView reloadData];
        
        //让底部控件结束刷新
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        YZLog(@"%@", error);
        
        //提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        //让底部控件结束刷新
        [self.userTableView.mj_footer endRefreshing];
    }];
    
}

/**
 时刻监测footer的状态
 */
- (void)checkFooterState
{
    YZRecommendCategory *rc = YZSelectedCategory;
    
    //每次刷新右边数据时，都控制footer显示或隐藏
    self.userTableView.mj_footer.hidden = (rc.users.count == 0);
    
    //让底部控件结束刷新
    if (rc.users.count == rc.total) {
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
    }
    else {
        [self.userTableView.mj_footer endRefreshing];
    }
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //两个tableView共用一个控制器，所以显示cell的时候要进行判断
    if (tableView == self.categoryTableView) { //左边类别表格
        return self.categories.count;
    }
    
    //监测footer的状态
    [self checkFooterState];
    
    //右边的用户表格
    return [YZSelectedCategory users].count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) { //左边类别表格
        YZRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:YZCategoryID];
        cell.category = self.categories[indexPath.row];
        return cell;
    }
    else { //右边的用户表格
        YZRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:YZUserID];
        
        cell.user = [YZSelectedCategory users][indexPath.row];
        return cell;
    }
}


#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //要避免网络延迟，导致加载某个category时，点击另一个category会显示前一个category数据的错误，
    //结束刷新
    [self.userTableView.mj_header endRefreshing];
    [self.userTableView.mj_footer endRefreshing];
    
    YZRecommendCategory *c = self.categories[indexPath.row];
    
    if (c.users.count) {
        //显示曾经的数据
        [self.userTableView reloadData];
    }
    else {
        //赶紧刷新表格，目的是：马上显示当前category的用户数据。不让使用者看见上一个category的残留数据
        [self.userTableView reloadData];
        
        //进入下拉刷新状态. 此时会调用loadNewUsers
        [self.userTableView.mj_header beginRefreshing];
    }
}


#pragma mark - 控制器的销毁
/**
 加载数据的时候，用户又可能点击“返回”。此时就要在销毁控制器的时候，停止AFTHTTPSessionManager的所有操作。
 */
- (void)dealloc
{
    //停止所有操作
    [self.manager.operationQueue cancelAllOperations];
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
