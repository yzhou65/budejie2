//
//  YZTopicVoiceView.m
//  budejie2
//
//  Created by Yue on 8/11/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZTopicVoiceView.h"
#import "YZTopic.h"
#import "UIImageView+WebCache.h"
#import "YZShowPictureViewController.h"

@interface YZTopicVoiceView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;

@end

@implementation YZTopicVoiceView

+ (instancetype)voiceView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone; //这个很重要。如果不设置autoresizing，就会导致picture的尺寸与下面设置的不一样（可能会超出范围）
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
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
    
    //图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    //播放次数
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    
    //播放时长
    NSInteger minute = topic.voicetime / 60;
    NSInteger second = topic.voicetime % 60;
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second]; //分和秒都要2位，不满2位用0填补。
}
@end
