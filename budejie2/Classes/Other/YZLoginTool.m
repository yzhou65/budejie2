//
//  YZLoginTool.m
//  budejie2
//
//  Created by Yue on 8/16/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZLoginTool.h"
#import "YZLoginRegisterViewController.h"

@implementation YZLoginTool

+ (void)setUid:(NSString *)uid
{
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUid
{
    return [self getUid:NO];
}

+ (NSString *)getUid:(BOOL)showLoginController
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    if (showLoginController) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            YZLoginRegisterViewController *login = [[YZLoginRegisterViewController alloc] init];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:login animated:YES completion:nil];
        });
    }
    
    return uid;
}

@end
