//
//  YZProgressView.m
//  budejie
//
//  Created by Yue on 8/10/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZProgressView.h"

@implementation YZProgressView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.roundedCorners = 2;
    self.progressLabel.textColor = [UIColor whiteColor];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [super setProgress:progress animated:animated];
    
    NSString *progressText = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    self.progressLabel.text = [progressText stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
