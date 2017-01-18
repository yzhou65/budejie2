//
//  YZAddTagViewController.h
//  budejie2
//
//  Created by Yue on 8/15/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZAddTagViewController : UIViewController
/** 获取tags的block */
@property(nonatomic, copy) void (^tagsBlock)(NSArray *tags);

/** 所有的标签 */
@property(nonatomic, strong) NSArray *tags;

@end
