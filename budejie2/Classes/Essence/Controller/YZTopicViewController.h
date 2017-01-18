//
//  YZTopicViewController.h
//  budejie
//
//  Created by Yue on 8/9/16.
//  Copyright © 2016 fda. All rights reserved.
//  最基本的帖子控制器

#import <UIKit/UIKit.h>


@interface YZTopicViewController : UITableViewController

/** 帖子类型(交给子类去实现) */
@property(nonatomic, assign) YZTopicType type;

@end
