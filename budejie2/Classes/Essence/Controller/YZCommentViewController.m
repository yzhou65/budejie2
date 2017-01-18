//
//  YZCommentViewController.m
//  budejie2
//
//  Created by Yue on 8/12/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZCommentViewController.h"
#import "YZTopicCell.h"
#import "YZTopic.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "YZComment.h"
#import "YZCommentHeaderView.h"
#import "YZCommentCell.h"

static NSString * const YZCommentId = @"comment";
//static NSInteger const YZHeaderLabelTag = 99; //绑定tag的方法不推荐

@interface YZCommentViewController () <UITableViewDelegate, UITableViewDataSource>
/** 工具条底部间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 最热评论 */
@property(nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property(nonatomic, strong) NSMutableArray *latestComments; //不要以new开头命名变量，系统会认为是new方法
/** 保存帖子的top_cmt */
@property(nonatomic, strong) YZComment *saved_top_cmt;

/** 当前的页码 */
@property(assign, nonatomic) NSInteger page;

/** manager */
@property(nonatomic, strong) AFHTTPSessionManager *manager;

/** 上一次选中的行号 */
@property(nonatomic, strong) NSIndexPath *selected;
@end

@implementation YZCommentViewController
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (NSMutableArray *)latestComments
{
    if (!_latestComments) {
        _latestComments = [NSMutableArray array];
    }
    return _latestComments;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBasic];
    
    [self setupHeader];
    
    [self setupRefresh];
}

- (void)setupBasic
{
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // cell的高度设置(ios8以后可以先给cell估计高度，然后让其自动dimension)
    self.tableView.estimatedRowHeight = 44; //自动尺寸之前必须设置估计高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //背景色
    self.tableView.backgroundColor = YZGlobalBg;
    
    //注册自定义cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZCommentCell class]) bundle:nil] forCellReuseIdentifier:YZCommentId];
    
    //去掉分隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //内边距
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, YZTopicCellMargin, 0);
}

- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    
    self.tableView.mj_footer.hidden = YES;
}

- (void)loadMoreComments
{
    //结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //页码
    NSInteger page = self.page + 1;
    
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"page"] = @(page);
    YZComment *cmt = [self.latestComments lastObject];
    params[@"lastcid"] = cmt.ID;
    
    [self.manager GET:budejie_url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) { //如果没有评论数据
            self.tableView.mj_footer.hidden = YES;
            return;
        }
        
        //最新评论
        NSArray *newComments = [YZComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments]; //注意不是addObject：而是addObjectsFromArray：
        
        //页码
        self.page = page;
        
        //刷新ui
        [self.tableView reloadData];
        
        //控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { //全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        } else {
            //结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadNewComments
{
    //结束之前的所有请求. 避免上拉和下拉刷新同时进行造成混乱
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    [self.manager GET:budejie_url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) { //如果没有评论数据
            [self.tableView.mj_header endRefreshing];
            return;
        }
        //最热评论
        self.hotComments = [YZComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        //最新评论
        self.latestComments = [YZComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        //页码
        self.page = 1;
        
        //刷新ui
        [self.tableView reloadData];
        //结束刷新状态
        [self.tableView.mj_header endRefreshing];
        
        //控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { //全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)setupHeader
{
    //创建header
    UIView *header = [[UIView alloc] init];
    
    //清空top_cmt
    if (self.topic.top_cmt) {
        self.saved_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    
    //添加cell到这个header上面
    YZTopicCell *cell = [YZTopicCell cell];
    cell.topic = self.topic;
    cell.size = CGSizeMake(YZScreenW, self.topic.cellHeight);
    [header addSubview:cell];
    
    //header高度
    header.height = self.topic.cellHeight + YZTopicCellMargin;
//    YZLog(@"%lf", header.height);
    
    //设置header
    self.tableView.tableHeaderView = header;
}

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    //键盘显示／隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //修改底部约束
    self.bottomSpace.constant = YZScreenH - frame.origin.y;
    
    //动画
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //恢复帖子的top_cmt
    if (self.topic.top_cmt) {
        self.topic.top_cmt = self.saved_top_cmt;
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    
    //取消所有任务
    [self.manager invalidateSessionCancelingTasks:YES];
}

/**
 返回第section组的所有评论数组
 */
- (NSArray *)commentsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latestComments;
    }
    return self.latestComments;
}

- (YZComment *)commentInIndexPath:(NSIndexPath *)indexPath
{
    return [self commentsInSection:indexPath.section][indexPath.row];
}



#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    if (hotCount) return 2; //有最热评论和最新评论
    if (latestCount) return 1; //只有最新评论1组
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    //隐藏尾部控件
    tableView.mj_footer.hidden = (latestCount == 0);
    
    if (section == 0) {
        return hotCount ? hotCount : latestCount;
    }
    
    //非第0组
    return latestCount;
}


/**
 用这个方法的好处是，最热评论或最新评论的排头不会因为滚动到下面而消失
 */
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *header = [[UIView alloc] init];
//    header.backgroundColor = YZGlobalBg;
//    
//    UILabel *label = [[UILabel alloc] init];
//    label.textColor = YZRGBColor(67, 67, 67);
//    label.width = 200;
//    label.x = YZTopicCellMargin;
//    label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [header addSubview:label];
//    
//    //设置文字
//    NSInteger hotCount = self.hotComments.count;
//    if (section == 0) {
//        label.text = hotCount ? @"最热评论123" : @"最新评论";
//    } else {
//        label.text = @"最新评论";
//    }
//    return header;
//}



/**
 显示最新评论和最热评论。header和footer也可以循环利用, 也可以注册(使用tableView的registerClass方法)。此处使用了自定封装的YZCommentHeaderView
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //先从缓存池中找header
    YZCommentHeaderView *header = [YZCommentHeaderView headerViewWithTableView:tableView];
    
    //设置label的数据
    NSInteger hotCount = self.hotComments.count;
    if (section == 0) {
        header.title = hotCount ? @"最热评论" : @"最新评论";
    } else {
        header.title = @"最新评论";
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:YZCommentId];
    cell.comment = [self commentInIndexPath:indexPath];
    
    return cell;
}


#pragma mark - <UITableViewDelegate>
/**
 在此方法中写退出键盘的代码，比在didScroll方法中写更好，因为didScroll调用太频繁，且退出键盘只需要一次
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

#pragma mark - MenuController related
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
        return;
    }
    else {
        //被点击的cell
        YZCommentCell *cell = (YZCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        //第一响应者
        [cell becomeFirstResponder];
        
        //显示MenuController
        UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *reply = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(reply:)];
        UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
        menu.menuItems = @[ding, reply, report];
        
        CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, cell.height * 0.5);
        [menu setTargetRect:rect inView:cell];
        [menu setMenuVisible:YES animated:YES];
    }
    
}

#pragma mark - MenuItem related
- (void)ding:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    YZLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
    
}

- (void)reply:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    YZLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

- (void)report:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    YZLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

/**
 header和footer也可以循环利用
 */
/*
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 //先从缓存池中找header
 static NSString *ID = @"header";
 UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
 
 UILabel *label = nil;
 if (header == nil) { //缓存池为空，自己创建
 header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:ID];
 header.contentView.backgroundColor = YZGlobalBg;
 //创建label
 label = [[UILabel alloc] init];
 label.textColor = YZRGBColor(67, 67, 67);
 label.width = 200;
 label.x = YZTopicCellMargin;
 label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
 label.tag = YZHeaderLabelTag; //绑定tag不推荐
 [header.contentView addSubview:label];
 }
 else { //从缓存池中取出来
 label = (UILabel *)[header viewWithTag:YZHeaderLabelTag];
 }
 
 //设置文字
 NSInteger hotCount = self.hotComments.count;
 if (section == 0) {
 label.text = hotCount ? @"最热评论123" : @"最新评论";
 } else {
 label.text = @"最新评论";
 }
 
 
 return header;
 }
 */
@end
