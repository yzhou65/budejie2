//
//  YZRecommendCategory.m
//  百思不得姐
//
//  Created by Yue on 8/6/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZRecommendCategory.h"
#import "MJExtension.h"

@implementation YZRecommendCategory
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

//+ (NSString *)replacedKeyFromPropertyName121:(NSString *)propertyName
//{
//    if ([propertyName isEqualToString:@"ID"]) {
//        return @"id";
//    }
//    return propertyName;
//}

- (NSMutableArray *)users
{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}

@end
