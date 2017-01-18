//
//  UIBarButtonItem+YZExtension.h
//  百思不得姐
//
//  Created by Yue on 8/5/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (YZExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
