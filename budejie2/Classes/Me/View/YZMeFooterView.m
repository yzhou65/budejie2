//
//  YZMeFooterView.m
//  budejie2
//
//  Created by Yue on 8/14/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZMeFooterView.h"
#import "AFNetworking.h"
#import "YZSquare.h"
#import "MJExtension.h"
#import "YZSquareButton.h"
#import "YZWebViewController.h"

@implementation YZMeFooterView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        //参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        //发送请求
        [[AFHTTPSessionManager manager] GET:budejie_url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *squares = [YZSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            [self createSquares:squares];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    return self;
}

/**
 创建方块
 */
- (void)createSquares:(NSArray *)squares
{
    int maxCols = 4; //一行最多4列
    
    //宽高
    CGFloat buttonW = YZScreenW / maxCols;
    CGFloat buttonH = buttonW;
    
    for (int i = 0; i < squares.count; i++) {
        //创建按钮
        YZSquareButton *btn = [YZSquareButton buttonWithType:UIButtonTypeCustom];
        
        //监听
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.square = squares[i]; //传递模型
        [self addSubview:btn];
        
        //计算frame
        int col = i % maxCols;
        int row = i / maxCols;
        
        btn.x = col * buttonW;
        btn.y = row * buttonH;
        btn.width = buttonW;
        btn.height = buttonH;
    }
    //计算footerView的高度
    //总页数 == (总个数 ＋ 每页最大数 － 1) / 每页最大数
    NSUInteger rows = (squares.count + maxCols - 1) / maxCols;
    self.height = rows * buttonH;
    
    //重绘
//    [self setNeedsDisplay];
}

- (void)buttonClick:(YZSquareButton *)button
{
//    YZLog(@"%@", button.square.url);
    if (![button.square.url hasPrefix:@"http"]) return;
    
    YZWebViewController *webVC = [[YZWebViewController alloc] init];
    webVC.url = button.square.url;
    webVC.title = button.square.name;
    
    //取出当前导航控制器
    UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)tabBarVC.selectedViewController;
    [nav pushViewController:webVC animated:YES];
}
@end
