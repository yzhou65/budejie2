//
//  YZTopicCell.h
//  budejie
//
//  Created by Yue on 8/9/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZTopic;

@interface YZTopicCell : UITableViewCell
/** 帖子 */
@property(nonatomic, strong) YZTopic *topic;

+ (instancetype)cell;

@end
