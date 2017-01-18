//
//  YZShowPictureViewController.m
//  budejie
//
//  Created by Yue on 8/10/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZShowPictureViewController.h"
#import "UIImageView+WebCache.h"
#import "YZTopic.h"
#import "SVProgressHUD.h"
#import "YZProgressView.h"

@interface YZShowPictureViewController ()
@property (weak, nonatomic) IBOutlet YZProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *imageView;
@end

@implementation YZShowPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //屏幕尺寸.可以定义为macro
//    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
//    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;

    //添加图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    //图片尺寸
    CGFloat pictureW = YZScreenW;
    CGFloat pictureH = pictureW * self.topic.height / self.topic.width;
    
    if (pictureH > YZScreenH) { //图片显示高度超过一个屏幕，需要滚动查看
        imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        self.scrollView.contentSize = CGSizeMake(0, pictureH);
    }
    else {
        imageView.size = CGSizeMake(pictureW, pictureH);
        imageView.centerY = YZScreenH * 0.5;
    }
    
    //立刻显示当前图片下载进度
    [self.progressView setProgress:self.topic.pictureProgress animated:NO];
    
    //下载图片
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [self.progressView setProgress:1.0 * receivedSize / expectedSize animated:NO];

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
}

- (IBAction)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save
{
    if (self.imageView.image == nil) { //图片还没下载完，不能保存
        [SVProgressHUD showErrorWithStatus:@"图片还未下载完毕"];
        return;
    }
    //将图片写入相册. @selector中的方法名不能乱写，会报错。此方法的头文件中有说明必须使用didFinishSavingWithError
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}
@end
