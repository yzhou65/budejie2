//
//  YZWebViewController.m
//  budejie2
//
//  Created by Yue on 8/14/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZWebViewController.h"
#import "NJKWebViewProgress.h"

@interface YZWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/** 进度代理对象 */
@property(nonatomic, strong) NJKWebViewProgress *progress;

@end

@implementation YZWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progress = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progress;
    
    __weak typeof(self) weakSelf = self; //定义一个weakSelf的弱引用，否则下面循环引用
    self.progress.progressBlock = ^(float progress){
        weakSelf.progressView.progress = progress;
        weakSelf.progressView.hidden = (progress == 1.0);
    };
    self.progress.webViewProxyDelegate = self;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (IBAction)refresh:(id)sender
{
    [self.webView reload];
}

- (IBAction)goBack:(id)sender
{
    [self.webView goBack];
}

- (IBAction)goForward:(id)sender
{
    [self.webView goForward];
}

#pragma mark - <UIWebViewDelegate>
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.goBackItem.enabled = webView.canGoBack;
    self.goForwardItem.enabled = webView.canGoForward;
}


@end
