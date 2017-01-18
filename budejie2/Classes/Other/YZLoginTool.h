//
//  YZLoginTool.h
//  budejie2
//
//  Created by Yue on 8/16/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZLoginTool : NSObject
/**
 检测是否登录. 若nil，则没有登录
 获得当前登录用户的uid
 */
+ (NSString *)getUid;

+ (NSString *)getUid:(BOOL)showLoginController;
@end
