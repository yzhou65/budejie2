//
//  YZEssenceViewController.m
//  百思不得姐
//
//  Created by Yue on 8/3/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZEssenceViewController.h"
#import "YZRecommendTagsViewController.h"
#import "YZTopicViewController.h"

@interface YZEssenceViewController () <UIScrollViewDelegate>
/** 标签栏底部的红色指示器 */
@property(nonatomic, weak) UIView *indicatorView;

/** 当前被选中的标签 */
@property(nonatomic, weak) UIButton *selectedBtn;

/** 顶部的标签 */
@property(nonatomic, weak) UIView *titlesView;

/** 中间的所有内容 */
@property(nonatomic, weak) UIScrollView *contentView;

@end

@implementation YZEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNav];
    
    //初始化子控制器
    [self setupChildControllers];
    
    //设置顶部的标签栏
    [self setupTitlesView];
    
    //设置下面的滚动内容
    [self setupContentView];
    
    
}

/**
 初始化子控制器
 */
- (void)setupChildControllers
{
    YZTopicViewController *all = [[YZTopicViewController alloc] init];
    all.title = @"全部";
    all.type = YZTopicTypeAll;
    [self addChildViewController:all];
    
    YZTopicViewController *video = [[YZTopicViewController alloc] init];
    video.title = @"视频";
    video.type = YZTopicTypeVideo;
    [self addChildViewController:video];
    
    YZTopicViewController *voice = [[YZTopicViewController alloc] init];
    voice.title = @"声音";
    voice.type = YZTopicTypeVoice;
    [self addChildViewController:voice];
    
    YZTopicViewController *pic = [[YZTopicViewController alloc]init];
    pic.title = @"图片";
    pic.type = YZTopicTypePicture;
    [self addChildViewController:pic];
    
    YZTopicViewController *word = [[YZTopicViewController alloc] init];
    word.title = @"段子";
    word.type = YZTopicTypeWord;
    [self addChildViewController:word];
    
}

/**
 设置顶部的标签栏
 */
- (void)setupTitlesView
{
    //标签栏整体
    UIView *titlesView = [[UIView alloc] init];
//    titlesView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
//    titlesView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titlesView.width = self.view.width;
    titlesView.height = YZTitlesViewH;
    titlesView.tag = -1;
    titlesView.y = YZTitlesViewY;
//    titlesView.alpha = 0.5; //这样做不好，因为会导致内部子控件也半透明。所以应该直接设置背景色的alpha
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    //每个子标签底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    //标签栏内部子标签
    CGFloat width = titlesView.width / self.childViewControllers.count; //每个子标签宽度
    CGFloat height = titlesView.height; //每个子标签高度
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        btn.height = height;
        btn.width = width;
        btn.x = i * width;
        
        UIViewController *vc = self.childViewControllers[i];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [titlesView addSubview:btn];
        
        //默认点击了第一个按钮(开始的默认点击不要动画，所以不调用titleClick:)
        if (i == 0) {
            btn.enabled = NO;
            self.selectedBtn = btn;
            
            //让按钮内部的label根据文字内容来计算尺寸
            [btn.titleLabel sizeToFit];
            self.indicatorView.width = btn.titleLabel.width;
            self.indicatorView.centerX = btn.centerX;
        }
    }
    
    [titlesView addSubview:indicatorView];
}

/**
 切换子控制器
 */
- (void)titleClick:(UIButton *)btn
{
    //修改按钮状态
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    
    //滚动动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = btn.titleLabel.width;
        self.indicatorView.centerX = btn.centerX;
    }];
    
    //滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = btn.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

/**
 设置下面的滚动内容
 */
- (void)setupContentView
{
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = self.view.bounds;
    
    //contentView滚动完成后需要加载内容，所以要使当前控制器成为其代理
    contentView.delegate = self;
    
    //分页效果
    contentView.pagingEnabled = YES;
    
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);//注意这个contentView是水平滚动的。上下滚动的，是每个tableViewController内部的tableView滚动。
    self.contentView = contentView;
    
    //默认显示第一个控制器view
    [self scrollViewDidEndScrollingAnimation:contentView];
    
    
//    contentView.width = self.view.width;
//    contentView.y = 99;
//    contentView.height = self.view.height - contentView.y - self.tabBarController.tabBar.height; //但是这样做没有穿透效果
}

/**
 设置导航栏
 */
- (void)setupNav
{
    //设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    //设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    
    //设置背景色
    self.view.backgroundColor = YZGlobalBg;
}

/**
 左上角按钮的监听
 */
- (void)tagClick
{
    YZRecommendTagsViewController *tags = [[YZRecommendTagsViewController alloc] init];
    [self.navigationController pushViewController:tags animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //添加子控制器的view
    //当前的索引
    NSInteger index = scrollView.contentOffset.x /  scrollView.width;
    
    //取出子控制器
    UITableViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; //修改控制器view的默认y值（默认值为20）
    vc.view.height = scrollView.height; //设置控制器view的height为整个屏幕的高度（默认是屏幕高度－20）
    
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    //点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}

@end
