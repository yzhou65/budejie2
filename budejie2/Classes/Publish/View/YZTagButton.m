//
//  YZTagButton.m
//  budejie2
//
//  Created by Yue on 8/15/16.
//  Copyright © 2016 fda. All rights reserved.
//

#import "YZTagButton.h"

@implementation YZTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.backgroundColor = YZTagBg;
        self.titleLabel.font = YZTagFont;
        
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self sizeToFit];
    self.width += 3 * YZTagMargin;
    self.height = YZTagH;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.x = 0;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + YZTagMargin;
    
}
@end
