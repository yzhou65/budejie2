//
//  YZRecommendCategory.h
//  百思不得姐
//
//  Created by Yue on 8/6/16.
//  Copyright © 2016 fda. All rights reserved.
//  推荐关注左边的数据类型

#import <Foundation/Foundation.h>

@interface YZRecommendCategory : NSObject

/** <#comment#> */
@property(assign, nonatomic) NSInteger ID;

/** <#comment#> */
@property(assign, nonatomic) NSInteger count;

/** <#Comment#> */
@property(nonatomic, copy) NSString *name;

/** 这个类别对应的用户数据  */
@property(nonatomic, strong) NSMutableArray *users;

/** 当前页 */
@property(assign, nonatomic) NSInteger currentPage;

/** 总数 */
@property(assign, nonatomic) NSInteger total;

@end
