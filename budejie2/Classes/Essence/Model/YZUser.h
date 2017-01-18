//
//  YZUser.h
//  budejie2
//
//  Created by Yue on 8/12/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZUser : NSObject
/** 用户名 */
@property(nonatomic, copy) NSString *username;
/** 性别 */
@property(nonatomic, copy) NSString *sex;
/** 头像 */
@property(nonatomic, copy) NSString *profile_image;


@end
