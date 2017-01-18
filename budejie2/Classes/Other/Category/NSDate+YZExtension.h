//
//  NSDate+YZExtension.h
//  budejie
//
//  Created by Yue on 8/9/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YZExtension)

/**
 计算from和self的差值
 */
- (NSDateComponents *)timeElapsedFrom:(NSDate *)from;

- (BOOL)isThisYear;

- (BOOL)isToday;

- (BOOL)isYesterday;
@end
