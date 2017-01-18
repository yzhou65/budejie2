//
//  YZTopicVideoView.h
//  budejie2
//
//  Created by Yue on 8/12/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZTopic;

@interface YZTopicVideoView : UIView

+ (instancetype)videoView;

/** 帖子模型 */
@property(nonatomic, strong) YZTopic *topic;
@end
