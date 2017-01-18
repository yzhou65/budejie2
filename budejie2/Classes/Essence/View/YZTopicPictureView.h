//
//  YZTopicPictureView.h
//  budejie
//
//  Created by Yue on 8/10/16.
//  Copyright © 2016 fda. All rights reserved.
//  图片帖子中间的内容

#import <UIKit/UIKit.h>

@class YZTopic;

@interface YZTopicPictureView : UIView

+ (instancetype)pictureView;

/** 帖子数据 */
@property(nonatomic, strong) YZTopic *topic;

@end
