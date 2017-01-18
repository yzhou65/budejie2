//
//  YZRecommendUser.h
//  百思不得姐
//
//  Created by Yue on 8/7/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZRecommendUser : NSObject

/** 头像 */
@property(nonatomic, copy) NSString *header;

/** 粉丝数 */
@property(assign, nonatomic) NSInteger fans_count;

/** 昵称 */
@property(nonatomic, copy) NSString *screen_name;

@end
