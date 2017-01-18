//
//  YZTopic.h
//  budejie
//
//  Created by Yue on 8/9/16.
//  Copyright © 2016 fda. All rights reserved.
//  帖子模型

#import <UIKit/UIKit.h>
@class  YZComment;

@interface YZTopic : NSObject
/** id */
@property(nonatomic, copy) NSString *ID;
/** 名称 */
@property(nonatomic, copy) NSString *name;
/** 头像 */
@property(nonatomic, copy) NSString *profile_image;
/** 发帖时间 */
@property(nonatomic, copy) NSString *create_time;
/** 文字内容 */
@property(nonatomic, copy) NSString *text;
/** 被顶的数量 */
@property(assign, nonatomic) NSInteger ding;
/** 被踩的数量 */
@property(assign, nonatomic) NSInteger cai;
/** 被转发的数量 */
@property(assign, nonatomic) NSInteger share;
/** 评论的数量 */
@property(assign, nonatomic) NSInteger comment;
/** 是否为新浪加V用户 */
@property(assign, nonatomic, getter=isSina_v) BOOL sina_v;
/** 图片的宽度 */
@property(assign, nonatomic) CGFloat width;
/** 图片的高度 */
@property(assign, nonatomic) CGFloat height;
/** 小图片的URL */
@property(nonatomic, strong) NSString *small_image;
/** 大图片的URL */
@property(nonatomic, strong) NSString *large_image;
/** 中图片的URL */
@property(nonatomic, strong) NSString *middle_image;
/** 帖子的类型 */
@property(assign, nonatomic) YZTopicType type;
/** 音频时长 */
@property(nonatomic, assign) NSInteger voicetime;
/** 视频时长 */
@property(assign, nonatomic) NSInteger videotime;
/** 播放次数 */
@property(assign, nonatomic) NSInteger playcount;
/** 最热评论（YZComment模型） */
@property(nonatomic, strong) YZComment *top_cmt; //百思不得姐服务器返回的最热评论虽然是个NSArray，但是长度总是1，所以没必要用数组，转而使用YZComment

/** qzone_uid */
@property(nonatomic, copy) NSString *qzone_uid;


/** 额外的辅助属性 */

/** cell的高度.写了readonly以后，系统就不会再自动生成_cellHeight成员变量了 */
@property(assign, nonatomic, readonly) CGFloat cellHeight;
/** 图片控件的frame */
@property(assign, nonatomic, readonly) CGRect pictureFrame;
/** 图片是否太大 */
@property(assign, nonatomic, getter=isBigPicture) BOOL bigPicture;
/** 图片的下载进度 */
@property(assign, nonatomic) CGFloat pictureProgress;

/** 声音控件的frame */
@property(assign, nonatomic, readonly) CGRect voiceFrame;

/** 视频控件的frame */
@property(assign, nonatomic, readonly) CGRect videoFrame;

@end
