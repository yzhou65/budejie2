//
//  YZComment.h
//  budejie2
//
//  Created by Yue on 8/12/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YZUser;

@interface YZComment : NSObject
/** id */
@property(nonatomic, copy) NSString *ID;
/** 音频时长 */
@property(assign, nonatomic) NSInteger voicetime;
/** 音频文件路径 */
@property(strong, nonatomic) NSString *voiceuri;
/** 评论的文字内容 */
@property(nonatomic, copy) NSString *content;
/** 被点赞的数量 */
@property(assign, nonatomic) NSInteger like_count;
/** 用户 */
@property(nonatomic, strong) YZUser *user;
@end
