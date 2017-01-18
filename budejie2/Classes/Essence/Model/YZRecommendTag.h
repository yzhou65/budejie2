//
//  YZRecommendTag.h
//  budejie
//
//  Created by Yue on 8/7/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZRecommendTag : NSObject

/** 图片 */
@property(nonatomic, copy) NSString *image_list;

/** 名字 */
@property(nonatomic, copy) NSString *theme_name;

/** 订阅数 */
@property(assign, nonatomic) NSInteger sub_number;

@end
