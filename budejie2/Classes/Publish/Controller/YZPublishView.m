//
//  YZPublishView.m
//  budejie
//
//  Created by Yue on 8/10/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZPublishView.h"
#import "YZVerticalButton.h"
#import "POP.h"

/** 动画相关 */
static CGFloat const YZAnimationDelay = 0.1;
static CGFloat const YZSpringFactor = 10;

@interface YZPublishView ()
/** 定义block的示例 */
@property(nonatomic, copy) void *(^completionBlock)(); //属性中定义block的写法和参数中block的写法不一样
@end

@implementation YZPublishView
//定义block的例子
- (void)test:(void (^)())completionBlock
{
    void (^block)() = ^{
        
    };
    block();
}

/**
 从xib中加载当前view
 */
+ (instancetype)publishView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

static UIWindow *window_; //global variable
+ (void)show
{
    //创建窗口。如果不写级别，就默认是normal级别，不能盖住状态栏
    //窗口级别：
    //UIWindowLevelNormal < UIWindowLevelStatusBar < UIWindowLevelAlert
    window_ = [[UIWindow alloc] init];
    window_.frame = [UIScreen mainScreen].bounds;
    window_.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    window_.hidden = NO;
    
    //添加发布界面
    YZPublishView *publishView = [YZPublishView publishView];
    publishView.frame = window_.bounds;
    [window_ addSubview:publishView];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //让窗口不能被点击
    self.userInteractionEnabled = NO;
    
    //数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    //中间6个按钮
    int maxCols = 3; //最大列数
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartY = (YZScreenH - 2 * buttonH) * 0.5;
    CGFloat buttonStartX = 20;
    CGFloat xMargin = (YZScreenW - 2 * buttonStartX - maxCols * buttonW) / (maxCols - 1);
    for (int i = 0; i < images.count; i++) {
        YZVerticalButton *btn = [[YZVerticalButton alloc] init];
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        //设置内容
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        // 计算X\Y
        int row = i / maxCols;
        int col = i % maxCols;
        CGFloat buttonX = buttonStartX + col * (xMargin + buttonW);
        CGFloat buttonEndY = buttonStartY + row * buttonH;
        CGFloat buttonBeginY = buttonEndY - YZScreenH;
        
        // 按钮动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springBounciness = YZSpringFactor;
        anim.springSpeed = YZSpringFactor;
        anim.beginTime = CACurrentMediaTime() + YZAnimationDelay * i;
        [btn pop_addAnimation:anim forKey:nil];
    }
    
    // 添加标语
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self addSubview:sloganView];
    
    // 标语动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    CGFloat centerX = YZScreenW * 0.5;
    CGFloat centerEndY = YZScreenH * 0.2;
    CGFloat centerBeginY = centerEndY - YZScreenH;
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBeginY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.beginTime = CACurrentMediaTime() + images.count * YZAnimationDelay;
    anim.springBounciness = YZSpringFactor;
    anim.springSpeed = YZSpringFactor;
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        // 标语动画执行完毕, 恢复点击事件
        self.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];
}

/**
 每一个“发视频”“发声音”等按钮的监听。其中定义了一个block
 */
- (void)buttonClick:(UIButton *)button
{
    [self cancelWithCompletionBlock:^{
        switch (button.tag) {
            case 0:
                YZLog(@"发视频");
                break;
            case 1:
                YZLog(@"发图片");
                break;
            case 2:
                YZLog(@"发段子");
                break;
            case 3:
                YZLog(@"发声音");
                break;
            case 4:
                YZLog(@"审帖");
                break;
            case 5:
                YZLog(@"离线下载");
                break;
            default:
                break;
        }
    }];
}

- (IBAction)cancel
{
    [self cancelWithCompletionBlock:nil];
}


/**
 先执行退出动画，再执行completionBlock
 */
- (void)cancelWithCompletionBlock:(void (^)())completionBlock
{
    //让窗口不能被点击
    self.userInteractionEnabled = NO;
    
    int beginIndex = 0; //第0个subview是“取消”按钮
//    YZLog(@"%@",self.subviews[1]);
    for (int i = beginIndex; i < self.subviews.count; i++) {
        UIView *subview = self.subviews[i];
        
        //按钮弹出可以不需要弹簧效果，所以就用BasicAnimation
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = subview.centerY + YZScreenH;
        
        //动画的执行节奏（一开始慢，后面很快）
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * YZAnimationDelay;
        [subview pop_addAnimation:anim forKey:nil];
        
        //监听最后一个动画
        if (i == self.subviews.count - 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                //销毁窗口
                [self removeFromSuperview];
                window_.hidden = YES; //注意要先隐藏window_，之后才能将其赋为nil
                window_ = nil;
                
                //执行传进来的completionBlock参数
                !completionBlock ? : completionBlock();
            }];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self cancelWithCompletionBlock:nil];
}

/**
 pop和Core Animation的区别
 1. Core Animation的动画只能添加到layer上
 2. pop的动画能添加到任何对象
 3. pop的底层并非基于Core Animation，是基于CADisplayLink
 */


@end
