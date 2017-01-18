//
//  YZCommentCell.h
//  budejie2
//
//  Created by Yue on 8/13/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YZComment;

@interface YZCommentCell : UITableViewCell
/** 评论 */
@property(nonatomic, strong) YZComment *comment;
@end
