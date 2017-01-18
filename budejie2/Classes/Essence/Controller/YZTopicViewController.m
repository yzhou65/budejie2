//
//  YZWordViewController.m
//  budejie
//
//  Created by Yue on 8/8/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZTopicViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "YZTopic.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "YZTopicCell.h"
#import "YZCommentViewController.h"
#import "YZNewViewController.h"

@interface YZTopicViewController ()
/** 帖子数据 */
@property(nonatomic, strong) NSMutableArray *topics;
/** 当前页码 */
@property(assign, nonatomic) NSInteger page;
/** 当加载下一页数据时，需要的参数 */
@property(nonatomic, copy) NSString *maxtime;
/** 上一次的请求参数 */
@property(nonatomic, strong) NSDictionary *params;

/** 上次选中的控制器索引 */
@property(assign, nonatomic) NSInteger lastSelectedIndex;
@end

@implementation YZTopicViewController

- (NSMutableArray *)topics
{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化表格
    [self setupTable];
    
    //添加显示正在刷新的控件
    [self setupRefresh];
    
    [self loadNewTopics];
}

static NSString * const YZTopicCellId = @"topic";
- (void)setupTable
{
    //给tableView设置一定内边距达到穿透效果
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = YZTitlesViewY + YZTitlesViewH;
    
    //设置滚动条的内边距
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZTopicCell class]) bundle:nil] forCellReuseIdentifier:YZTopicCellId];

    //监听tabBar点击的通知
    [YZNoteCenter addObserver:self selector:@selector(tabBarSelect) name:YZTabBarDidSelectNotification object:nil];
}

- (void)tabBarSelect
{
    // 如果连续选中两次，刷新
    if (self.lastSelectedIndex == self.tabBarController.selectedIndex && self.view.isShowingOnKeyWindow) {
        [self.tableView.mj_header beginRefreshing];
    }
    
    //记录这一次选中的索引
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
}

- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES; //根据拖拽自动调整透明度
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

#pragma mark -a参数
- (NSString *)a
{
    return [self.parentViewController isKindOfClass:[YZNewViewController class]] ? @"newlist" : @"list";
}

#pragma mark -数据处理
/**
 加载新的帖子数据
 */
- (void)loadNewTopics
{
    //结束上拉刷新
    [self.tableView.mj_footer endRefreshing];
    
    //参数
    NSMutableDictionary  *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    self.params = params;
    
    //发送请求
    [[AFHTTPSessionManager manager] GET:budejie_url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        //        [responseObject writeToFile:@"/Users/yue/Desktop/duanzi.plist" atomically:YES];
        
        if (self.params != params) return;
        
        //存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        //字典 -> 模型
        self.topics = [YZTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
        //页码
        self.page = 0;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
        
        if (self.params != params) return;
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
        //此处不用恢复页码。因为上面的代码是在第一次成功加载之后才给页码赋值。
    }];
}

/**
 加载更多帖子数据
 */
- (void)loadMoreTopics
{
    //结束下拉
    [self.tableView.mj_header endRefreshing];
    
    self.page++;
    
    //参数
    NSMutableDictionary  *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    NSInteger page = self.page + 1;
    params[@"page"] = @(page);
    params[@"maxtime"] = self.maxtime;
    self.params = params;
    
    //发送请求
    [[AFHTTPSessionManager manager] GET:budejie_url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if (self.params != params) return;
        
        //存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        NSArray *newTopics = [YZTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:newTopics];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        //存储页码
        self.page = page;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
        
        if (self.params != params) return;
        
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:YZTopicCellId];
    
    cell.topic = self.topics[indexPath.row];
    return cell;
}

#pragma mark - delegate methods
/**
 计算cell的高度，此方法会频繁地调用。每次加载cell的时候就会调用。所以计算cell高度最好只做一次，并且要将这个计算过程封装到YZTopic模型中。
 此方法会在cellForRowAtIndexPath之前调用。cellHeight在此处计算完后，再去上面的cellForRowAtIndexPath方法传入模型
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出帖子模型
    YZTopic *topic = self.topics[indexPath.row];
    
    return topic.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZCommentViewController *commentVC = [[YZCommentViewController alloc] init];
    commentVC.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVC animated:YES];
}


@end
