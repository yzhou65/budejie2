//
//  YZTopicVoiceView.h
//  budejie2
//
//  Created by Yue on 8/11/16.
//  Copyright © 2016 fda. All rights reserved.
//  声音帖子中间的内容

#import <UIKit/UIKit.h>

@class YZTopic;

@interface YZTopicVoiceView : UIView

+ (instancetype)voiceView;

/** 帖子模型 */
@property(nonatomic, strong) YZTopic *topic;

@end
