//
//  YZTopicPictureView.m
//  budejie
//
//  Created by Yue on 8/10/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZTopicPictureView.h"
#import "YZTopic.h"
#import "UIImageView+WebCache.h"
#import "YZProgressView.h"
#import "YZShowPictureViewController.h"

@interface YZTopicPictureView ()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** gif标识 */
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/** 查看大图按钮 */
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
/** 进度条控件 */
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;

@end

@implementation YZTopicPictureView

+ (instancetype)pictureView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone; //这个很重要。如果不设置autoresizing，就会导致picture的尺寸与下面设置的不一样（可能会超出范围）
    
    //给图片添加监听
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)];
    [self.imageView addGestureRecognizer:tapRecognizer];
}

- (void)showPicture
{
    YZShowPictureViewController *showPictureVC = [[YZShowPictureViewController alloc] init];
    showPictureVC.topic = self.topic;
    
    //当前类是个UIView，没有presentViewController方法，所以要拿到keyWindow的根控制器
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPictureVC animated:YES completion:nil];
}

- (void)setTopic:(YZTopic *)topic
{
    _topic = topic;
    
    //避免网速慢，导致cell的循环利用出错.要在每次进入的时候立刻显示最新的图片下载进度。防止因为网速慢，导致显示的是其他图片的下载进度
    [self.progressView setProgress:topic.pictureProgress animated:NO];
    
    /**
     在不知道图片扩展名的情况下，如何知道图片的真实类型？
     取出图片数据的第一个字节，就可以判断出图片的真实类型
     */
    
    //设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        
        //计算进度值
        topic.pictureProgress = 1.0 * receivedSize / expectedSize;
        
        //显示进度值
        [self.progressView setProgress:topic.pictureProgress animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        
        if (!topic.isBigPicture) {
            return;
        }
        
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureFrame.size, YES, 0.0);
        
        //将下载完的image对象绘制到图形上下文
        CGFloat width = topic.pictureFrame.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        //获得图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        //结束图形上下文
        UIGraphicsEndImageContext();
    }];
    
    //判断是否为gif
    NSString *extension = topic.large_image.pathExtension;
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    
    //判断是否显示“点击查看全图”
    if (topic.isBigPicture) { //大图
        self.seeBigButton.hidden = NO;
    }
    else { //非大图
        self.seeBigButton.hidden = YES;
    }
}

@end
