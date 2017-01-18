//
//  YZTagTextField.h
//  budejie2
//
//  Created by Yue on 8/15/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZTagTextField : UITextField
/** 按删除键的回调 */
@property(nonatomic, copy) void (^deleteBlock)();

@end
